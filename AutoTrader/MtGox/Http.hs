{-# LANGUAGE OverloadedStrings, ScopedTypeVariables, NoMonomorphismRestriction #-}

module AutoTrader.MtGox.Http
( httpTicker
, MtGoxHttpSettings (..)
, module AutoTrader.MtGox.Http.Types
)
where


import AutoTrader.MtGox.Types
import AutoTrader.MtGox.Types.Instances
import AutoTrader.MtGox.Types.Lenses
import AutoTrader.MtGox.Http.Types

import Network.HTTP.Conduit
import Data.Aeson 
import Data.Default
import Data.Time.Units
import Control.Applicative
import Control.Monad (when, forever)
import Control.Monad.Reader
import Control.Lens
import Control.Concurrent (threadDelay)
import Control.Exception (handle, catch)
import Control.Monad.State


type TickerApp m a = ReaderT MtGoxHttpSettings (StateT (Maybe MtGoxTicker) m) a


runTickerApp :: Monad m => MtGoxHttpSettings -> TickerApp m a -> m a
runTickerApp settings app = evalStateT (runReaderT app settings) Nothing


liveTicker :: (Maybe MtGoxTicker -> MtGoxTicker -> IO ()) -> TickerApp IO ()
liveTicker f = do
    url <- httpURL <$> ask
    timeout <- httpRetryDelayMicroSeconds <$> ask
    tickerTxt <- liftIO . retryOnTimeout timeout . simpleHttp $ url
    let mTicker =  tickerData <$> decode tickerTxt
    prev        <- get
    case mTicker of
        Nothing     -> liftIO $ putStrLn "Error: Could not decode response."
        Just ticker -> do put mTicker
                          liftIO $ when (mTicker /= prev) (f prev ticker)
   

type TimeoutMilliSeconds = Int

retryOnTimeout :: TimeoutMilliSeconds -> IO a -> IO a
retryOnTimeout timeout action = catch action $ \(_ :: HttpException) -> 
                            do putStrLn "Timed out. Trying again."
                               threadDelay timeout
                               action 



-- TODO: move settings into a ReaderT or similar. HttpPoller monad would probably work well.
httpTicker :: PriceHandler -> MtGoxHttpSettings -> IO ()
httpTicker handler settings = runTickerApp settings app
                       where app = do liftIO $ putStrLn "Starting HTTP polling."
                                      forever $ do
                                            liveTicker handler
                                            liftIO . threadDelay $ httpRetryDelayMicroSeconds settings

-- This data type and instance are a bit annoying. It's here because the ticker is wrapped in
-- different object wrapper, depending on if it's polling or websocket
data PollTickerResult = PollTickerResult { tickerData :: MtGoxTicker }
instance FromJSON PollTickerResult where
    parseJSON (Object o) = PollTickerResult <$> o .: "data"
    parseJSON _          = error "Invalid JSON input"


