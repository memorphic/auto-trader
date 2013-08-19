{-# LANGUAGE NoMonomorphismRestriction #-}

-- | Export all the MtGox modules, while hiding internals
--
--
module AutoTrader.MtGox 
( module AutoTrader.MtGox.Types 
, module AutoTrader.MtGox.Types.Lenses
, ticker
, with
) 
where

-- | Don't import/re-export record accessors as they are redundant due to lenses
import AutoTrader.MtGox.Types ( MtGoxTicker 
                              , MtGoxPrice
                              , PriceHandler 
                              , MtGoxSettings (..)
                              , MtGoxConnectionType(..)
                              )
import AutoTrader.MtGox.Types.Lenses
import AutoTrader.MtGox.Types.Instances
import AutoTrader.MtGox.Http
import AutoTrader.MtGox.WebSocket
import Data.Default


-- | nice synonym (borrowed from Diagrams lib)
with :: Default a => a
with = def


ticker :: PriceHandler -> MtGoxSettings -> IO ()
ticker h settings = case mtgoxConnectionType settings of
    MtGoxWebSocket -> websocketTicker h $ mtgoxWebSocket settings
    MtGoxHttp      -> httpTicker h $ mtgoxHttp settings
