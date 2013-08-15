{-# LANGUAGE OverloadedStrings #-}


import AutoTrader.MtGox
import AutoTrader.MtGox.Http (httpTicker) 
import AutoTrader.MtGox.WebSocket (websocketTicker)
import Control.Lens


printLastPrice :: PriceHandler
printLastPrice prev curr = putStrLn $ show lastPrice ++ " ("++ show lastTime ++")"
                where 
                     lastPrice = curr ^. tkLast . prValue
                     lastTime = curr ^. tkLastUpdateTime


main :: IO ()
main = httpTicker printLastPrice
--main = websocketTicker printLastPrice

