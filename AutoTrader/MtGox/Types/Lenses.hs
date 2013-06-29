{-# LANGUAGE TemplateHaskell #-}

module AutoTrader.MtGox.Types.Lenses where

import Control.Lens.TH
import AutoTrader.MtGox.Types

makeLenses ''MtGoxTicker
makeLenses ''MtGoxPrice


