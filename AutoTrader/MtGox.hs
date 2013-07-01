-- | Export all the MtGox modules, while hiding internals
--
--
module AutoTrader.MtGox 
( module AutoTrader.MtGox.Types 
, module AutoTrader.MtGox.Types.Lenses
) 
where

-- | hide record accessor functions as they are redundant due to lenses
import AutoTrader.MtGox.Types hiding ( _tkLast
                                     , _tkLastAll
                                     , _tkBuy
                                     , _tkSell
                                     , _tkLastLocal
                                     , _tkLastOrig
                                     , _tkLastUpdateTime 
                                     )
import AutoTrader.MtGox.Types.Lenses
import AutoTrader.MtGox.Types.Instances
