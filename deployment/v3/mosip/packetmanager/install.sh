#!/bin/sh
# Installs packetmanager
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=packetmanager
CHART_VERSION=1.1.5

echo Create namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing packetmanager
helm -n $NS install packetmanager mosip/packetmanager -f values.yaml --version $CHART_VERSION
