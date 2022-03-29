#!/bin/bash

# Installs External services in correct order
## Usage: ./install-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

ROOT_DIR=`pwd`/../

echo Installing External services

cd $ROOT_DIR/postgres/cluster
./install.sh
./init_db.sh

cd $ROOT_DIR/iam
./install.sh
./keycloak_init.sh

cd $ROOT_DIR/hsm/softhsm
./install.sh

cd $ROOT_DIR/object-store/minio/
./install.sh
cd $ROOT_DIR/object-store
./cred.sh

cd $ROOT_DIR/antivirus/clamav
./install.sh

cd $ROOT_DIR/activemq/aws
./install.sh

cd $ROOT_DIR/kafka
./install.sh

echo Biosdk services needed to be deployed separately in pilot or production setup. In testing environment will use biosdk services provided my MOSIP which will be installed as part of the MOSIP services installation.

echo ABIS needed to be up and running outside the MOSIP cluster and should be able to connect to the activeMQ. For testing Purpose MOSIP has provided a mock stimulator for the same named as mock-abis which will be deployed as part of the MOSIP services installation.

cd $ROOT_DIR/msg-gateway
./install.sh

echo All External services deployed an configured sucessfully.
