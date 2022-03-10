#!/bin/bash

# Installs MOSIP services in correct order
## Usage: ./install-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

ROOT_DIR=`pwd`/../

echo Installing MOSIP services

cd $ROOT_DIR/config-server 
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/artifactory
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/keymanager
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/websub
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/kernel
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/packetmanager
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/datashare
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/prereg
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/idrepo
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/pms
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/mock-abis
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/regproc
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/admin
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/ida
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/print
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/mosip-file-server
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/resident
./install.sh
cd $ROOT_DIR

cd $ROOT_DIR/regclient
./install.sh
cd $ROOT_DIR

echo All MOSIP services deployed sucessfully.
