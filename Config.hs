{-# LANGUAGE OverloadedStrings #-}
-- derived from git://github.com/fujimura/spot.git
module Config
    ( get
    ) where

import           Control.Applicative ((<$>))
import qualified Data.HashMap.Strict as M
import           Data.Maybe          (fromMaybe)
import           Data.Text
import qualified Data.Yaml           as Y

get :: FilePath -> Text -> Text -> IO Text
get path env configName = do
	file <- Y.decodeFile path
	allConfigs <- maybe (fail "Invalid Yaml file") return file
	configs <- getObject env allConfigs
	lookupScalar configName configs
	where
		-- lookupScalar :: Text -> (M.HashMap Text Y.Value) -> IO Text
		lookupScalar k m =
			case M.lookup k m of
				Just (Y.String t) -> return t
				Just _          -> fail $ "Invalid value for: " ++ show k
				Nothing         -> fail $ "Not found:" ++ show k

		-- getObject :: Text -> Y.Value -> Maybe (M.HashMap Text Y.Value)
		getObject env v = do
			envs <- fromObject v
			maybe
				(error $ "Could not find environment: " ++ show env)
				return $ fromObject =<< M.lookup env envs

		-- fromObject :: Y.Value -> Maybe (M.HashMap Text Y.Value)
		fromObject m =
			case m of
				Y.Object o -> return o
				_        -> fail "Invalid JSON format"
