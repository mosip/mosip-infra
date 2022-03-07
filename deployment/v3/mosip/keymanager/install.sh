#!/bin/sh
# Installs keymanager
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=keymanager
CHART_VERSION=1.2.0

echo Creating $NS namespace
kubectl create ns $NS

echo Istio label
kubectl label ns $NS istio-injection=enabled --overwrite
kubectl apply -n $NS -f idle_timeout_envoyfilter.yaml
helm repo update

echo Copy configmaps
./copy_cm.sh

echo Running keygenerator. This may take a few minutes..
helm -n $NS install kernel-keygen mosip/keygen --wait --wait-for-jobs --version $CHART_VERSION -f keygen_values.yaml

echo Installing keymanager
helm -n $NS install keymanager mosip/keymanager --version $CHART_VERSION

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Installed keymanager services
