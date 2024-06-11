#!/bin/bash
# Installs readuser-util
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=readuser-util
IAM_NS=keycloak
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_readuser-util() {

  echo Installing readuser-util
  helm -n $NS install readuser-util mosip/readuser-utill --version $CHART_VERSION -f values.yaml --wait
  helm -n $IAM_NS install readuser-iam-init mosip/keycloak-init --version $CHART_VERSION -f readuser-init-values.yaml --wait

  echo Installed readuser-util
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_readuser-util  # calling function