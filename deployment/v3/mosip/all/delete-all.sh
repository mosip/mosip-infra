#!/bin/bash
# Deletes MOSIP services
## Usage: ./delete-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

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
                   "regclient"
                   "mosip-file-server"
                   "keymanager"
                   "kernel"
                   "config-server"
                   "artifactory"
                   "websub"
                   )

echo Deleting MOSIP services.

for i in "${module[@]}"
do
  cd $ROOT_DIR/"$i"
  ./delete.sh
done

echo All the MOSIP services deleted.
