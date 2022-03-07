#!/bin/sh
# Installs artifactory
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=artifactory
CHART_VERSION=1.2.0

echo Create $NS namespace
kubectl create ns $NS 

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Installing artifactory
helm -n $NS install artifactory mosip/artifactory --version $CHART_VERSION 

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed artifactory service
