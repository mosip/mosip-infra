#!/bin/bash
# Installs resident-app service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=resident
CHART_VERSION=12.0.1-B2

echo Create namespace
kubectl create namespace $NS

function resident_app() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Installing Resident
  helm -n $NS install resident-app mosip/resident-app --version $CHART_VERSION

  echo Intalled resident services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
resident_app   # calling function