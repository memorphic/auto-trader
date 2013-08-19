{-# LANGUAGE OverloadedStrings #-}


import AutoTrader.MtGox
import Control.Lens
import Data.Default


printLastPrice :: PriceHandler
printLastPrice prev curr = putStrLn $ show lastPrice ++ " ("++ show lastTime ++")"
                where 
                     lastPrice = curr ^. tkLast . prValue
                     lastTime = curr ^. tkLastUpdateTime


httpTicker :: IO ()
httpTicker = ticker printLastPrice with { mtgoxConnectionType = MtGoxHttp }

websocketTicker :: IO ()
websocketTicker = ticker printLastPrice with { mtgoxConnectionType = MtGoxWebSocket }


