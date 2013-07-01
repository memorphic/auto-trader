-- | Types related to objects received from MtGox services
--
--
module AutoTrader.MtGox.Types where

import Data.Text.Lazy


data MtGoxTicker = MtGoxTicker
  { _tkLast           :: MtGoxPrice
  , _tkLastAll        :: MtGoxPrice
  , _tkBuy            :: MtGoxPrice
  , _tkSell           :: MtGoxPrice
  , _tkLastLocal      :: MtGoxPrice  
  , _tkLastOrig       :: MtGoxPrice  
  , _tkLastUpdateTime :: Integer
  } 
  deriving (Show, Eq)


{-
data MtGoxTickerFull = MtGoxTickerFull
  { _tkHigh           :: MtGoxPrice
  , _tkLow            :: MtGoxPrice
  , _tkLast           :: MtGoxPrice
  , _tkLastAll        :: MtGoxPrice
  , _tkBuy            :: MtGoxPrice
  , _tkSell           :: MtGoxPrice
  , _tkLastOrig       :: MtGoxPrice  
  , _tkLastLocal      :: MtGoxPrice  
  , _tkAvg            :: MtGoxPrice
  , _tkVolWeightedAvg :: MtGoxPrice
  , _tkLastUpdateTime :: Integer
  } 
  deriving (Show, Eq)
-}


data MtGoxPrice = MtGoxPrice
  { _prCurrency     :: Text
  , _prValue        :: Double
  , _prDisplay      :: Text
  , _prDisplayShort :: Text
  }
  deriving (Show, Eq)



