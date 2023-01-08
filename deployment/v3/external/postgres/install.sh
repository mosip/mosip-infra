#!/bin/sh
# Installs postgres inside the cluster
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=postgres

helm repo update
echo Create $NS namespace
kubectl create namespace $NS
kubectl label ns $NS istio-injection=enabled --overwrite

echo Installing  Postgres
helm -n $NS install postgres mosip/postgresql --version 10.16.2 -f values.yaml --wait
echo Installed Postgres

echo Installing gateways and virtual services
POSTGRES_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-postgres-host})
echo Internal domain: $INTERNAL
helm -n $NS install istio-addons chart/istio-addons --set postgresHost=$POSTGRES_HOST --wait
