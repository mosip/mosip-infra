#!/bin/sh
# Installs websub
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=websub
CHART_VERSION=12.0.1

echo Create $NS namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing websub
helm -n $NS install websub-consolidator mosip/websub-consolidator --version $CHART_VERSION --wait
helm -n $NS install websub mosip/websub --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed websub services
