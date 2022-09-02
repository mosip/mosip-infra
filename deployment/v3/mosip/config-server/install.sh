#!/bin/sh
# Installs config-server
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=config-server
CHART_VERSION=12.0.2

read -p "Is values.yaml for config-server chart set correctly as part of Pre-requisites?(Y/n) " yn
if [ $yn = "Y" ]; then read -p "Are config-server secrets installed using install_secrets.sh?(Y/n) " yn; fi
if [ $yn = "Y" ]
  then
    echo Create $NS namespace
    kubectl create ns $NS

    echo Istio label
    kubectl label ns $NS istio-injection=enabled --overwrite
    helm repo update

    echo Copy configmaps
    ./copy_cm.sh

    echo Copy secrets
    ./copy_secrets.sh

    echo Installing config-server
    helm -n $NS install config-server mosip/config-server -f values.yaml --wait --version $CHART_VERSION
    echo Installed Config-server.
    break
  else
    echo Exiting the MOSIP installation. Please meet the pre-requisites and than start again.
    kill -9 `ps --pid $$ -oppid=`; exit
fi
