#!/bin/bash


echo "Begin running jenkins benchmark script: Thrust benchmarks"
set -x

# CONVENTION: The working directory is passed as the first argument.
CHECKOUT=$1
shift

if [ "$CHECKOUT" == "" ]; then
 echo "Replacing CHECKOUT with pwd" 
 CHECKOUT=`pwd`
fi

if [ "$JENKINS_GHC" == "" ]; then
  export JENKINS_GHC=7.6.3
fi

echo "Running benchmarks remotely on server `hostname`"

which cabal
cabal --version

unset GHC
unset GHC_PKG
unset CABAL

set -e

DIR=`pwd`  
echo $DIR 
if [ ! -d HSBencher ]; then 
git clone git@github.com:rrnewton/HSBencher
fi

(cd HSBencher; git submodule init; git submodule update) 

#Compile The runbenchmarks script 
cabal sandbox init 
cabal install --disable-documentation --disable-library-profiling ./HSBencher/hsbencher/ ./HSBencher/hsbencher-fusion ./HSBencher/hgdata --reinstall 

cabal install run_benchmarks.cabal --bindir=. --program-suffix=.exe



export TRIALS=1
# Parfunc account, registered app in api console:
CID=905767673358.apps.googleusercontent.com
SEC=2a2H57dBggubW1_rqglC7jtK

# Obsidian doc ID:  
TABID=1TsG043VYLu9YuU58EaIBdQiqLDUYcAXxBww44EG3
# https://www.google.com/fusiontables/DataSource?docid=1TsG043VYLu9YuU58EaIBdQiqLDUYcAXxBww44EG3

# Enable upload of benchmarking data to a Google Fusion Table:
# ./run_benchmarks.exe --keepgoing --trials=$TRIALS --fusion-upload=$TABID --clientid=$CID --clientsecret=$SEC $*
echo "Running Benchmarks"
./run_benchmarks.exe --keepgoing --trials=$TRIALS --fusion-upload --name=Obsidian_bench_data --clientid=$CID --clientsecret=$SEC $*

