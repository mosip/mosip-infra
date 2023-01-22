#!/bin/bash
# Deletes MOSIP services
## Usage: ./delete-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

function Deleting_all() {
  ROOT_DIR=`pwd`/../

  declare -a module=("regproc"
                     "resident"
                     "prereg"
                     "admin"
                     "idrepo"
                     "print"
                     "ida"
                     "packetmanager"
                     "datashare"
                     "pms"
                     "mock-abis"
                     "mock-mv"
                     "regclient"
                     "mosip-file-server"
                     "keymanager"
                     "kernel"
                     "config-server"
                     "artifactory"
                     "websub"
                     "biosdk"
                     )
  echo Deleting MOSIP services.

  for i in "${module[@]}"
  do
    cd $ROOT_DIR/"$i"
    sed -i 's/\r$//' delete.sh
    ./delete.sh
  done

  echo All the MOSIP services deleted.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
Deleting_all   # calling function
