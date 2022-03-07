#!/bin/bash
# Deletes MOSIP services
## Usage: ./delete-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

WORK_DIR=`pwd`

echo Deleting MOSIP services

cd regproc
./delete.sh
cd $WORK_DIR

cd resident
./delete.sh
cd $WORK_DIR

cd prereg
./delete.sh
cd $WORK_DIR

cd idrepo
./delete.sh
cd $WORK_DIR

cd print
./delete.sh
cd $WORK_DIR

cd ida
./delete.sh
cd $WORK_DIR

cd packetmanager
./delete.sh
cd $WORK_DIR

cd datashare
./delete.sh
cd $WORK_DIR

cd pms
./delete.sh
cd $WORK_DIR

cd mock-abis
./delete.sh
cd $WORK_DIR

cd admin
./delete.sh
cd $WORK_DIR

cd mosip-file-server
./delete.sh
cd $WORK_DIR

cd regclient
./delete.sh
cd $WORK_DIR

cd keymanager
./delete.sh
cd $WORK_DIR

cd kernel
./delete.sh
cd $WORK_DIR

cd config-server
./delete.sh
cd $WORK_DIR

cd artifactory
./delete.sh
cd $WORK_DIR

cd websub
./delete.sh
cd $WORK_DIR

echo Deleted MOSIP services
