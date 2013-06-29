{-# LANGUAGE OverloadedStrings, TemplateHaskell #-}


import AutoTrader.MtGox

import Network.HTTP.Conduit
import qualified Data.ByteString.Lazy as L
import qualified Data.Map             as M
import Data.Aeson
import Control.Applicative
import Control.Monad (join)
import Data.Text.Lazy
import Data.Aeson.Encode.Pretty
import Control.Lens
import Control.Concurrent (threadDelay)


tickerURL =  "https://data.mtgox.com/api/2/BTCUSD/money/ticker" 



main = loop 0
    where loop prev = do
                ticker <- simpleHttp tickerURL
                let Just res = decode ticker :: Maybe MtGoxTicker
                let val = res ^. (tkLast . prValue)
                if val /= prev
                   then putStrLn $ show val
                   else return ()
                threadDelay 2000000
                loop val




