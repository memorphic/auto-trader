{-# LANGUAGE OverloadedStrings, NoMonomorphismRestriction, TemplateHaskell #-} 

-- | Used for loading key and secret from filesystem
--
--
--
module AutoTrader.MtGox.Security
( MtGoxKey (..)
, KeyName, KeySecret
, getMtGoxKey
)
where

import Control.Applicative
import Data.Text.Lazy

type KeyName = Text
type KeySecret = Text

data MtGoxKey = MtGoxKey KeyName KeySecret
    deriving (Show, Read, Eq)


-- todo: This is a temp location that won't work after packaging etc
getMtGoxKey :: IO MtGoxKey
getMtGoxKey = read <$> readFile ".keys/auto-trader1.key"
