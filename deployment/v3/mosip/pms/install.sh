#!/bin/sh
# Installs all PMS charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pms
CHART_VERSION=12.0.1

echo Create $NS namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Installing partner manager
helm -n $NS install pms-partner mosip/pms-partner --version $CHART_VERSION

echo Installing policy manager
helm -n $NS install pms-policy mosip/pms-policy --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Intalled pms services
