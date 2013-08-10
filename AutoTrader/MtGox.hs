-- | Export all the MtGox modules, while hiding internals
--
--
module AutoTrader.MtGox 
( module AutoTrader.MtGox.Types 
, module AutoTrader.MtGox.Types.Lenses
) 
where

-- | Don't import/re-export record accessors as they are redundant due to lenses
import AutoTrader.MtGox.Types ( MtGoxTicker, MtGoxPrice )
import AutoTrader.MtGox.Types.Lenses
import AutoTrader.MtGox.Types.Instances
