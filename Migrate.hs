{-# LANGUAGE OverloadedStrings #-}

import           Control.Exception
import           Control.Monad
import           Control.Monad.Trans     (liftIO, MonadIO)
import qualified Data.Text               as T
import qualified Database.Persist        as P
import qualified Database.Persist.Sqlite     as PSql
import qualified Database.Persist.GenericSql as PGen
import qualified Database.Persist.GenericSql.Internal as PGenIn
import           System.Directory        (doesDirectoryExist)

import qualified Config as Config
import           Model

main :: IO ()
main = do
    d <- doesDirectoryExist "db"
    unless d $ fail "Directory ./db does not exist. Retry after creating ./db"

    development <- Config.get (T.unpack "config/database.yml") "development" "database"
    pool <- PSql.createSqlitePool development 3
    runDB pool $ PGen.runMigration migrateAll

runDB :: MonadIO m => PGen.ConnectionPool -> PGen.SqlPersist IO a -> m a
runDB pool action = liftIO $ PGen.runSqlPool action pool
