{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction #-} 
module AutoTrader.MtGox.Types.Aeson where

import Control.Applicative
import Control.Monad
import Data.Aeson 
import AutoTrader.MtGox.Types

{-
instance FromJSON MtGoxTickerFull where
     parseJSON (Object o) = do
                 dat         <- join $ parseJSON <$> o .: "data"
                 let getPrice name = join $ parseJSON <$> dat .: name 
                 prHigh      <- getPrice "high"
                 prLow       <- getPrice "low"
                 prLast      <- getPrice "last"
                 prLastAll   <- getPrice "last_all"
                 prBuy       <- getPrice "buy"
                 prSell      <- getPrice "sell"
                 prLastOrig  <- getPrice "last_orig"
                 prLastLocal <- getPrice "last_local"
                 prAvg       <- getPrice "avg"    
                 prVWAP      <- getPrice "vwap"   
                 time        <- read <$> dat .: "now"   
                 return $ MtGoxTickerFull 
                            { _tkHigh           = prHigh
                            , _tkLow            = prLow
                            , _tkLast           = prLast
                            , _tkLastAll        = prLastAll
                            , _tkBuy            = prBuy
                            , _tkSell           = prSell
                            , _tkLastOrig       = prLastOrig
                            , _tkLastLocal      = prLastLocal
                            , _tkAvg            = prAvg
                            , _tkVolWeightedAvg = prVWAP
                            , _tkLastUpdateTime = time
                            }
          
     parseJSON _ = fail "Failed to parse result"
-}

instance FromJSON MtGoxTicker where
     parseJSON (Object o) = do
                 let getPrice name = join $ parseJSON <$> o .: name 
                 prLast      <- getPrice "last"
                 prLastAll   <- getPrice "last_all"
                 prBuy       <- getPrice "buy"
                 prSell      <- getPrice "sell"
                 prLastOrig  <- getPrice "last_orig"
                 prLastLocal <- getPrice "last_local"
                 time        <- read <$> o .: "now"   
                 return $ MtGoxTicker 
                            { _tkLast           = prLast
                            , _tkLastAll        = prLastAll
                            , _tkBuy            = prBuy
                            , _tkSell           = prSell
                            , _tkLastOrig       = prLastOrig
                            , _tkLastLocal      = prLastLocal
                            , _tkLastUpdateTime = time
                            }
          
     parseJSON _ = fail "Failed to parse result"


instance FromJSON MtGoxPrice where
     parseJSON (Object o) = do
                 curr         <- o .: "currency"
                 val          <- read <$> o .: "value"
                 display      <- o .: "display"
                 displayShort <- o .: "display_short"
                 return $ MtGoxPrice 
                           { _prCurrency     = curr
                           , _prValue        = val
                           , _prDisplay      = display
                           , _prDisplayShort = displayShort
                           }

     parseJSON _          = fail "Failed to parse price"





