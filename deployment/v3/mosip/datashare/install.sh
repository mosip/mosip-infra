#!/bin/sh
# Installs Datashare
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=datashare
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing Datashare
helm -n $NS install datashare mosip/datashare -f values.yaml --wait --version $CHART_VERSION
