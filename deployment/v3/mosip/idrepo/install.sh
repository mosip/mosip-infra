#!/bin/sh
# Installs idrepo
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=idrepo
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label 
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running salt generator job
helm -n $NS install idrepo-saltgen  mosip/idrepo-saltgen --wait --wait-for-jobs

echo Running credential
helm -n $NS install credential mosip/credential --version $CHART_VERSION

echo Running credential request service
helm -n $NS install credentialrequest mosip/credentialrequest --version $CHART_VERSION

echo Running identity service
helm -n $NS install identity mosip/identity --version $CHART_VERSION

echo Running vid service
helm -n $NS install vid mosip/vid --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Intalled idrepo services
