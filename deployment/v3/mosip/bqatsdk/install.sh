#!/bin/bash
# Installs BqatSDK
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=bqatsdk
CHART_VERSION=12.0.2

echo Create $NS namespace
kubectl create ns $NS

function installing_bqatsdk() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Installing Bqatsdk server
  helm -n $NS install bqat-sdk /home/bhuminathan/develop/helm/mosip-helm/charts/bqat-sdk -f values.yaml --version $CHART_VERSION

  echo Bqatsdk service installed sucessfully.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_bqatsdk   # calling function
