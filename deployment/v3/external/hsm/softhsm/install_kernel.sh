#!/bin/sh
# Installs Softhsm for Kernel 
## Usage: ./install_kernel.sh [kubeconfig]
## To change the name of complete installation:  --set fullnameOverride=softhsm-kernel


if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=softhsm-kernel
CHART_VERSION=1.1.5

echo Create namespaces
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing Softhsm for Kernel
helm -n $NS install softhsm mosip/softhsm -f values.yaml --version $CHART_VERSION

