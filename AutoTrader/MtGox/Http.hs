{-# LANGUAGE OverloadedStrings #-}

module AutoTrader.MtGox.Http 
( 
    httpTicker
  , PriceHandler
  , TickerApp 
)
where


import AutoTrader.MtGox

import Network.HTTP.Conduit
import Data.Aeson (decode)
import Control.Applicative
import Control.Monad (when, forever)
import Control.Lens
import Control.Concurrent (threadDelay)
import Control.Exception (handle, catch)
import Control.Monad.State

data MtGoxLevel = MtGoxFull | MtGoxFast

tickerURL :: MtGoxLevel -> String
tickerURL MtGoxFull = "https://data.mtgox.com/api/2/BTCUSD/money/ticker" 
tickerURL MtGoxFast = "https://data.mtgox.com/api/2/BTCUSD/money/ticker_fast" 

type TickerApp = StateT (Maybe MtGoxTicker) IO ()
type PriceHandler = Maybe MtGoxTicker -> MtGoxTicker -> IO ()


liveTicker :: (Maybe MtGoxTicker -> MtGoxTicker -> IO ()) -> TickerApp
liveTicker f = do
    tickerData  <- liftIO . retryOnTimeout . simpleHttp $ tickerURL MtGoxFast
    let mTicker =  decode tickerData
    prev        <- get
    put mTicker
    liftIO $ case mTicker of
        Nothing     -> putStrLn "Error: Could not decode response."
        Just ticker -> when (mTicker /= prev) (f prev ticker)
   

retryOnTimeout :: IO a -> IO a
retryOnTimeout action = catch action $ \ResponseTimeout -> 
                            do putStrLn "Timed out. Trying again."
                               threadDelay 5000000
                               action 


httpTicker :: PriceHandler -> IO ()
httpTicker handler = evalStateT app Nothing
                       where app = forever $ do
                                       liveTicker handler
                                       liftIO $ threadDelay 2000000