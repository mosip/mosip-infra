#!/bin/bash

# Installs MOSIP services in correct order
## Usage: ./install-all.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

ROOT_DIR=`pwd`/../

declare -a module=("landing-page"
                   "docker-secrets"
                   "captcha"
                   "conf-secrets"
                   "config-server"
                   "artifactory"
                   "keymanager"
                   "websub"
                   "kernel"
                   "masterdata-loader"
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
                   "partner-onboarder"
                   "mosip-file-server"
                   "resident"
                   "resident-app"
                   "regclient"
                   )

echo Installing MOSIP services

for i in "${module[@]}"
do
  cd $ROOT_DIR/"$i"
  ./install.sh
done

echo All MOSIP services deployed sucessfully.
