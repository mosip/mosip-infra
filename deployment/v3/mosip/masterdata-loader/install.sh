#!/bin/sh
# Loads sample masterdata 
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=masterdata-loader
CHART_VERSION=12.0.1

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_secrets.sh

echo Loading masterdata
helm -n $NS install masterdata-loader  mosip/masterdata-loader --version $CHART_VERSION
