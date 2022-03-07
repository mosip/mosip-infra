#!/bin/sh
# Installs sample print service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=print
CHART_VERSION=1.2.0

echo Create $NS namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing print service
helm -n $NS install print-service mosip/print-service --wait --version $CHART_VERSION
