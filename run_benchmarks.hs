#!/usr/bin/env runghc
{-# LANGUAGE NamedFieldPuns #-}

-- | This script runs all Harlan benchmarks.  It is based on a Haskell
-- benchmarking framework called HSBencher.  Its main advantage is
-- that it supports uploading of benchmark timings to a Google Fusion
-- Table.
-- Requires hsbencher >= 0.2

import Control.Monad
import Data.Maybe
import qualified Data.ByteString.Char8 as B
import System.Directory
import System.FilePath
import System.Exit
import System.Environment (getArgs)
import System.Process
import GHC.Conc (getNumProcessors)
import System.IO.Unsafe (unsafePerformIO)
import Debug.Trace

import Data.Monoid

import HSBencher 
import HSBencher.Backend.Fusion  (defaultFusionPlugin)
import HSBencher.Backend.Dribble (defaultDribblePlugin)

import HSBencher.Types
import HSBencher.Internal.Logging (log)
import HSBencher.Internal.MeasureProcess
import HSBencher.Internal.Utils (runLogged, defaultTimeout)
import Prelude hiding (log)
--------------------------------------------------------------------------------

main :: IO ()
main = defaultMainModifyConfig myconf

all_benchmarks :: [Benchmark DefaultParamMeaning]
all_benchmarks =
  [ (mkBenchmark "Reduce/Makefile" [elems] defaultCfgSpc)
    { progname = Just "thrust-reduce" } 
  | elems  <- [ show (2^n) | n <- [8..25] ] -- 256 to 32M
  ] ++ 
  [ (mkBenchmark "Scan/Makefile" [elems] defaultCfgSpc)
    { progname = Just "thrust-scan" } 
  | elems  <- [ show (2^n) | n <- [8..25] ] -- 256 to 32M
  ] ++
  [ (mkBenchmark "Sort/Makefile" [elems] defaultCfgSpc)
    { progname = Just "thrust-sort" }
  | elemts <- [ show (2^n) | n <- [8..25] ]] -- 256 to 32M

  
-- | Default configuration space over which to vary settings:
--   This is a combination of And/Or boolean operations, with the ability
defaultCfgSpc = And []

-- | Here we have the option of changing the HSBencher config
myconf :: Config -> Config
myconf conf =
  conf
   { benchlist = all_benchmarks
   , plugIns   = [ SomePlugin defaultFusionPlugin,
                   SomePlugin defaultDribblePlugin ]
   , harvesters =
     customTagHarvesterInt "ELEMENTS_PROCESSED" `mappend`
     customTagHarvesterDouble "TRANSFER_TO_DEVICE" `mappend`
     customTagHarvesterInt "BYTES_TO_DEVICE" `mappend`
     customTagHArvesterInt "BYTES_FROM_DEVICE" `mappend`
     harvesters conf

   }

