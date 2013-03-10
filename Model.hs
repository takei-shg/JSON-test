{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE KindSignatures       #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeFamilies         #-}
module Model where

import           Control.Applicative ((<$>))
import           Control.Monad (mzero)
import           Data.Text
import           Database.Persist
import           Database.Persist.TH
import qualified Data.Aeson as A

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persist|

User json
    name Text
    email Text
    editor Editor
    UniqueUser email
    deriving Show

|]

data Editor
    = VIM | EMACS
    deriving (Show, Read, Eq, Enum)
 
derivePersistField "Editor"

-- $(deriveJSON id ''Editor)
instance A.FromJSON Editor where
    parseJSON (A.Object v) = read <$> (v A..: "editor")
    parseJSON _            = mzero

instance A.ToJSON Editor where
    toJSON VIM = A.object [ "editor" A..= ("VIM" :: String) ]
    toJSON EMACS = A.object [ "editor" A..= ("EMACS" :: String) ]
