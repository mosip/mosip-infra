#!/bin/sh
# Installs postgres inside the cluster
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=postgres

echo Create namespace $NS
kubectl create namespace $NS
kubectl label ns $NS istio-injection=enabled --overwrite

echo Installing  postgres
helm -n $NS install postgres bitnami/postgresql -f values.yaml --wait

echo Installing gateways, vs
INTERNAL=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
echo Internal domain: $INTERNAL
helm -n $NS install istio-addons chart/istio-addons --set internalHost=$INTERNAL
