#!/bin/sh
# Installs mock-mv
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=mock-smtp
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
helm repo update

echo "Copy configmaps"
./copy_cm.sh

SMTP_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-smtp-host})

echo Installing mock-smtp
helm -n $NS install mock-smtp mosip/mock-smtp --set istio.hosts\[0\]=$SMTP_HOST --version $CHART_VERSION

kubectl -n $NS get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Intalled mock-smtp services