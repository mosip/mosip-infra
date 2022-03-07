#!/bin/bash

# Installs MOSIP services in correct order
## Usage: ./install-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

WORK_DIR=`pwd`

echo Installing MOSIP services

cd config-server 
./install.sh
cd $WORK_DIR

cd artifactory
./install.sh
cd $WORK_DIR

cd keymanager
./install.sh
cd $WORK_DIR

cd websub
./install.sh
cd $WORK_DIR

cd kernel
./install.sh
cd $WORK_DIR

cd packetmanager
./install.sh
cd $WORK_DIR

cd datashare
./install.sh
cd $WORK_DIR

cd prereg
./install.sh
cd $WORK_DIR

cd idrepo
./install.sh
cd $WORK_DIR

cd pms
./install.sh
cd $WORK_DIR

cd mock-abis
./install.sh
cd $WORK_DIR

cd regproc
./install.sh
cd $WORK_DIR

cd admin
./install.sh
cd $WORK_DIR

cd ida
./install.sh
cd $WORK_DIR

cd print
./install.sh
cd $WORK_DIR

cd mosip-file-server
./install.sh
cd $WORK_DIR

cd resident
./install.sh
cd $WORK_DIR


cd regclient
./install.sh
cd $WORK_DIR

echo All the MOSIP services deployed sucessfully
