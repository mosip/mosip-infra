#!/bin/bash
# Installs sample print service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosipcertmanager
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS 

function installing_mosipcertmanager() {
  echo Istio label
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Copy secrets
  sed -i 's/\r$//' copy_secrets.sh
  ./copy_secrets.sh

  echo Installing mosipcertmanager
  helm -n $NS install mosipcertmanager mosip/mosipcertmanager --wait --version $CHART_VERSION
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_mosipcertmanager   # calling function
