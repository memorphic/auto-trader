{-# LANGUAGE OverloadedStrings #-}


import AutoTrader.MtGox
import AutoTrader.MtGox.Http (httpTicker, PriceHandler)
import Control.Lens


printLastPrice :: PriceHandler
printLastPrice prev curr = putStrLn . show . lastPrice $ curr
                   where 
                     lastPrice = (^. tkLast . prValue)


main :: IO ()
main = httpTicker printLastPrice

