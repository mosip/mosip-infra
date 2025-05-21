#!/bin/bash
# Installs MinIO using helm chart inside MOSIP cluster
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=minio
ISTIO_ADDONS_CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS
kubectl label ns $NS istio-injection=enabled --overwrite

function installing_minio() {
  echo Installing minio
  helm -n minio install minio bitnami/minio -f values.yaml --version 15.0.6

  echo Installing gateways and virtualservice
  helm -n $NS install istio-addons mosip/istio-addons --version=$ISTIO_ADDONS_CHART_VERSION -f istio-addons-values.yaml

  echo Helm installed. Next step is to execute the cred.sh to update secrets in s3 namespace
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_minio   # calling function
