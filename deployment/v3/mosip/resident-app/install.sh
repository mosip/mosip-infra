#!/bin/sh
# Installs resident-app service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=resident
CHART_VERSION=12.0.1-B2

echo Create namespace
kubectl create namespace $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing Resident
helm -n $NS install resident-app mosip/resident-app --version $CHART_VERSION

echo Intalled resident services
                               
