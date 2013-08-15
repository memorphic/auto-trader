-- | Export all the MtGox modules, while hiding internals
--
--
module AutoTrader.MtGox 
( module AutoTrader.MtGox.Types 
, module AutoTrader.MtGox.Types.Lenses

, PriceHandler -- convenience alias for price change handlers
) 
where

-- | Don't import/re-export record accessors as they are redundant due to lenses
import AutoTrader.MtGox.Types ( MtGoxTicker, MtGoxPrice )
import AutoTrader.MtGox.Types.Lenses
import AutoTrader.MtGox.Types.Instances


type PriceHandler = Maybe MtGoxTicker -> MtGoxTicker -> IO ()
