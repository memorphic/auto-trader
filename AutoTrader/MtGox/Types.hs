-- | Types related to objects received from MtGox services
--
--
module AutoTrader.MtGox.Types where

import Data.Text.Lazy
import Data.Default
import AutoTrader.MtGox.Http.Types
import AutoTrader.MtGox.WebSocket.Types

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


data MtGoxPrice = MtGoxPrice
  { _prCurrency     :: Text
  , _prValue        :: Double
  , _prDisplay      :: Text
  , _prDisplayShort :: Text
  }
  deriving (Show, Eq)


-- | TODO: after full monad impl, this won't be needed
type PriceHandler = Maybe MtGoxTicker -> MtGoxTicker -> IO ()

-- TODO: Add constructor for 'both'
data MtGoxConnectionType = MtGoxWebSocket | MtGoxHttp 
    deriving( Read, Show, Eq )

data MtGoxSettings = MtGoxSettings 
                        { mtgoxWebSocket      :: MtGoxWSSettings
                        , mtgoxHttp           :: MtGoxHttpSettings
                        , mtgoxConnectionType :: MtGoxConnectionType
                        }
    deriving (Show, Read)

instance Default MtGoxSettings where
    def = MtGoxSettings 
            { mtgoxWebSocket      = def
            , mtgoxHttp           = def
            , mtgoxConnectionType = MtGoxWebSocket
            }
