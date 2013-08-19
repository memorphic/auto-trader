
module AutoTrader.MtGox.WebSocket.Types
(
    MtGoxWSSettings( .. ) 
)
where


import Data.Default

data MtGoxWSSettings = MtGoxWSSettings 
                { wsHost   :: String
                , wsPort   :: Int
                , wsPath   :: String
                , wsOrigin :: Maybe String
                } deriving (Show, Read)

instance Default MtGoxWSSettings where
    def =  MtGoxWSSettings 
                { wsHost   = "websocket.mtgox.com" 
                , wsPort   = 80
                , wsPath   = "/mtgox"
                , wsOrigin = Just "Http://www.mtgox.com"
                }
