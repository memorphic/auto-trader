

module AutoTrader.MtGox.Http.Types
( 
    MtGoxHttpSettings( .. )
)
where


import Data.Default


data MtGoxHttpSettings = MtGoxHttpSettings
                { httpURL                    :: String
                , httpPollDelayMicroSeconds  :: Int
                , httpRetryDelayMicroSeconds :: Int
                } deriving (Show, Read)

instance Default MtGoxHttpSettings where
    def = MtGoxHttpSettings
                { httpURL = "https://data.mtgox.com/api/2/BTCUSD/money/ticker_fast"
                , httpPollDelayMicroSeconds  = 2000000
                , httpRetryDelayMicroSeconds = 5000000
                }
                                                       
