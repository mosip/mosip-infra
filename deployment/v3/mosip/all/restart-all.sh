#!/bin/bash

# Restarts all the  MOSIP services.
## Usage: ./restart-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

ROOT_DIR=`pwd`/../

declare -a module=("config-server"
                   "artifactory"
                   "keymanager"
                   "websub"
                   "kernel"
                   "biosdk"
                   "packetmanager"
                   "datashare"
                   "prereg"
                   "idrepo"
                   "pms"
                   "mock-abis"
                   "regproc"
                   "admin"
                   "ida"
                   "print"
                   "mosip-file-server"
                   "resident"
                   "regclient"
                   )

echo Restarting MOSIP services

for i in "${module[@]}"
do
  cd $ROOT_DIR/"$i"
  ./restart.sh
done

echo All MOSIP services restarted sucessfully.
