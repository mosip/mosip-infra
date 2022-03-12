#!/bin/bash

# Installs MOSIP services in correct order
## Usage: ./install-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

ROOT_DIR=`pwd`/../

declare -a module=("config-server"
                   "artifactory"
                   "keymanager"
                   "websub"
                   "kernel"
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

echo Installing MOSIP services

for i in "${module[@]}"
do
  cd $ROOT_DIR/"$i"
  ./install.sh
done

echo All MOSIP services deployed sucessfully.
