#!/bin/sh
# Installs config-server
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=config-server
CHART_VERSION=1.2.0

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
