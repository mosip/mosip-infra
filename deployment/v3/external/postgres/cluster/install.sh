#!/bin/sh
# Installs postgres inside the cluster
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=postgres

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add mosip https://mosip.github.io/mosip-helm

echo Create namespace $NS
kubectl create namespace $NS
kubectl label ns $NS istio-injection=enabled --overwrite

echo Installing  postgres
helm -n $NS install postgres mosip/postgresql --version 10.16.2 -f values.yaml --wait

echo Installing gateways, vs
INTERNAL=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
echo Internal domain: $INTERNAL
helm -n $NS install istio-addons chart/istio-addons --set internalHost=$INTERNAL
