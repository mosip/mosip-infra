#!/bin/bash

# Restarts all the  MOSIP services.
## Usage: ./restart-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

function Restarting_all() {
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
                     "mock-mv"
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
    sed -i 's/\r$//' restart.sh
    ./restart.sh
  done

  echo All MOSIP services restarted sucessfully.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
Restarting_all   # calling function