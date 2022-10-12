#!/bin/sh
# Installs mock-abis
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=abis
CHART_VERSION=12.0.1-beta

echo Create $NS namespace
kubectl create ns $NS 

echo Copy configmaps
./copy_cm.sh

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing mock-abis
helm -n $NS install mock-abis mosip/mock-abis --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Intalled mock-abis services
