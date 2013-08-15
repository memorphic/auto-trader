{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module AutoTrader.MtGox.Http 
( 
    httpTicker
)
where


import AutoTrader.MtGox

import Network.HTTP.Conduit
import Data.Aeson 
import Control.Applicative
import Control.Monad (when, forever)
import Control.Lens
import Control.Concurrent (threadDelay)
import Control.Exception (handle, catch)
import Control.Monad.State

tickerURL = "https://data.mtgox.com/api/2/BTCUSD/money/ticker_fast" 

type TickerApp = StateT (Maybe MtGoxTicker) IO ()

liveTicker :: (Maybe MtGoxTicker -> MtGoxTicker -> IO ()) -> TickerApp
liveTicker f = do
    tickerTxt <- liftIO . retryOnTimeout . simpleHttp $ tickerURL
    let mTicker =  tickerData <$> decode tickerTxt
    prev        <- get
    case mTicker of
        Nothing     -> liftIO $ putStrLn "Error: Could not decode response."
        Just ticker -> do put mTicker
                          liftIO $ when (mTicker /= prev) (f prev ticker)
   

retryOnTimeout :: IO a -> IO a
retryOnTimeout action = catch action $ \(_ :: HttpException) -> 
                            do putStrLn "Timed out. Trying again."
                               threadDelay 5000000
                               action 


httpTicker :: PriceHandler -> IO ()
httpTicker handler = evalStateT app Nothing
                       where app = do liftIO $ putStrLn "Starting HTTP polling."
                                      forever $ do
                                            liveTicker handler
                                            liftIO $ threadDelay 2000000


-- This data type and instance are a bit annoying. It's here because the ticker is wrapped in
-- different object wrapper, depending on if it's polling or websocket
data PollTickerResult = PollTickerResult { tickerData :: MtGoxTicker }
instance FromJSON PollTickerResult where
    parseJSON (Object o) = PollTickerResult <$> o .: "data"
