#!/bin/bash

# Installs External services in correct order
## Usage: ./install-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

function installing_all() {
  ROOT_DIR=`pwd`/../

  echo Installing External services

  cd $ROOT_DIR/postgres
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

  cd $ROOT_DIR/activemq
  ./install.sh

  cd $ROOT_DIR/kafka
  ./install.sh

  echo Biosdk services needed to be deployed separately in pilot or production setup. In testing environment will use biosdk services provided my MOSIP which will be installed as part of the MOSIP services installation.

  echo ABIS needed to be up and running outside the MOSIP cluster and should be able to connect to the activeMQ. For testing Purpose MOSIP has provided a mock stimulator for the same named as mock-abis which will be deployed as part of the MOSIP services installation.

  cd $ROOT_DIR/msg-gateway
  ./install.sh

  cd $ROOT_DIR/docker-secrets
  ./install.sh

  cd $ROOT_DIR/conf-secrets
  ./install.sh

  cd $ROOT_DIR/landing-page
  ./install.sh
  
  cd $ROOT_DIR/captcha
  ./install.sh
  
  echo All External services deployed an configured sucessfully.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_all   # calling function

