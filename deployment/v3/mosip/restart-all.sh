#!/bin/bash
# Rstarts MOSIP services in anorder
## Usage: ./restart-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

WORK_DIR=`pwd`

echo Restarting MOSIP services

cd config-server 
./restart.sh
cd $WORK_DIR

cd artifactory
./restart.sh
cd $WORK_DIR

cd keymanager
./restart.sh
cd $WORK_DIR

cd websub
./restart.sh
cd $WORK_DIR

cd kernel
./restart.sh
cd $WORK_DIR

cd packetmanager
./restart.sh
cd $WORK_DIR

cd datashare
./restart.sh
cd $WORK_DIR

cd prereg
./restart.sh
cd $WORK_DIR

cd idrepo
./restart.sh
cd $WORK_DIR

cd pms
./restart.sh
cd $WORK_DIR

cd mock-abis
./restart.sh
cd $WORK_DIR

cd regproc
./restart.sh
cd $WORK_DIR

cd admin
./restart.sh
cd $WORK_DIR

cd ida
./restart.sh
cd $WORK_DIR

cd print
./restart.sh
cd $WORK_DIR

cd resident
./restart.sh
cd $WORK_DIR

cd mosip-file-server
./restart.sh
cd $WORK_DIR

cd regclient
./restart.sh
cd $WORK_DIR

echo Restarted MOSIP services
