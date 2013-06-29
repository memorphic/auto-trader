{-# LANGUAGE OverloadedStrings, TemplateHaskell, NoMonomorphismRestriction #-}

module AutoTrader.MtGox.Types where


import Control.Lens.TH
import Data.Text.Lazy


data MtGoxTicker = MtGoxTicker
  {
    _tkHigh           :: MtGoxPrice
  , _tkLow            :: MtGoxPrice
  , _tkLast           :: MtGoxPrice
  , _tkLastAll        :: MtGoxPrice
  , _tkBuy            :: MtGoxPrice
  , _tkSell           :: MtGoxPrice
  , _tkLastOrig       :: MtGoxPrice  
  , _tkAvg            :: MtGoxPrice
  , _tkVolWeightedAvg :: MtGoxPrice
  , _tkLastUpdateTime :: Integer
  } 
  deriving (Show, Eq)



data MtGoxPrice = MtGoxPrice
  { _prCurrency     :: Text
  , _prValue        :: Double
  , _prDisplay      :: Text
  , _prDisplayShort :: Text
  }
  deriving (Show, Eq)



