#!/bin/bash
# Installs postgres inside the cluster
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=postgres
ISTIO_ADDONS_CHART_VERSION=1.0.0-develop

helm repo update
echo Create $NS namespace
kubectl create namespace $NS
kubectl label ns $NS istio-injection=enabled --overwrite

function installing_postgres() {
  echo Installing  Postgres
  helm -n $NS install postgres bitnami/postgresql \
  --set image.repository="mosipint/postgresql" \
  --set image.tag="16.0.0-debian-11-r13" \
  --version 13.1.5 -f values.yaml --wait
  echo Installed Postgres
  echo Installing gateways and virtual services
  helm -n $NS install istio-addons mosip/istio-addons --version $ISTIO_ADDONS_CHART_VERSION -f istio-addons-values.yaml --wait
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_postgres   # calling function
