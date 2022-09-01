#!/bin/sh
# Installs sample print service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=tusd
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing tusd service
helm -n $NS install tusd-service mosip/tusd --wait --version $CHART_VERSION
