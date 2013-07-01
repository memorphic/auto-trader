{-# LANGUAGE OverloadedStrings, TemplateHaskell #-}


import AutoTrader.MtGox

import Network.HTTP.Conduit
import Data.Aeson (decode)
import Control.Monad (when)
import Control.Lens
import Control.Concurrent (threadDelay)
import Control.Exception (handle)

data MtGoxLevel = MtGoxFull | MtGoxFast

tickerURL :: MtGoxLevel -> String
tickerURL MtGoxFull = "https://data.mtgox.com/api/2/BTCUSD/money/ticker" 
tickerURL MtGoxFast = "https://data.mtgox.com/api/2/BTCUSD/money/ticker_fast" 

main :: IO ()
main = loop 0
  where loop prev = handle startAgain $ do
             ticker <- simpleHttp $ tickerURL MtGoxFast
             case decode ticker :: Maybe MtGoxTicker of
               Nothing  -> do putStrLn "Error: Could not decode response."
                              delayed $ loop prev
               Just res -> do let val = res ^. (tkLast . prValue)
                              when (val /= prev) $
                                  putStrLn $ show val
                              delayed $ loop val
        --
        startAgain ResponseTimeout = do putStrLn "Disconnected. Trying again."
                                        delayed $ loop 0
        --
        delayed f = threadDelay 1000000 >> f




