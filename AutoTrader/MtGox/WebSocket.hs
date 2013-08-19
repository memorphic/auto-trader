{-# LANGUAGE OverloadedStrings, ScopedTypeVariables #-}

module AutoTrader.MtGox.WebSocket
( websocketTicker
, MtGoxWSSettings (..)
)
where


import AutoTrader.MtGox.Types
import AutoTrader.MtGox.Types.Instances
import AutoTrader.MtGox.Types.Lenses
import AutoTrader.MtGox.WebSocket.Types


import qualified Network.WebSockets as WS
import Data.Aeson 
import Data.Default
import Control.Applicative
import Control.Monad (when, forever)
import Control.Monad.Trans (liftIO)
import Control.Monad.State


type TickerApp = StateT (Maybe MtGoxTicker) (WS.WebSockets WS.Hybi00) ()

liveTicker :: (Maybe MtGoxTicker -> MtGoxTicker -> IO ()) -> TickerApp
liveTicker f = do
    tickerTxt   <- lift $ WS.receiveData
    let mTicker =  tickerData <$> decode tickerTxt
    prev        <- get
    case mTicker of
        -- there are also depth messages intermingled with the ticker messages, so
        -- often it will fail to parse. Just ignore those for now. In order to
        -- differentiate depth messages from bad data, I probably will have to 
        -- parse them too...
        Nothing     -> return () 
        Just ticker -> do put mTicker
                          liftIO $ when (mTicker /= prev) (f prev ticker)
   

websocketTicker ::  PriceHandler -> MtGoxWSSettings -> IO ()
websocketTicker handler settings = WS.connectWith (wsHost settings)
                                                  (wsPort settings)
                                                  (wsPath settings)
                                                  (wsOrigin settings) Nothing app
                    where app = do liftIO $ putStrLn "Connected to Websocket."
                                   forever $ evalStateT (liveTicker handler) Nothing




-- This data type and instance are a bit annoying. It's here because the ticker is wrapped in
-- different object wrapper, depending on if it's polling or websocket
data WSTickerResult = WSTickerResult { tickerData :: MtGoxTicker }
instance FromJSON WSTickerResult where
    parseJSON (Object o) = WSTickerResult <$> o .: "ticker"
    parseJSON _          = error "Invalid JSON input"

