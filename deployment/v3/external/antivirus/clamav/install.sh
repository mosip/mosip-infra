#!/bin/bash
# Installs Clamav
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=clamav
CHART_VERSION=2.4.1

echo Create $NS namespace
kubectl create ns $NS 

function installing_Clamav() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo add wiremind https://wiremind.github.io/wiremind-helm-charts
  helm repo update

  echo Installing Clamav
  helm -n $NS install clamav wiremind/clamav -f values.yaml --version $CHART_VERSION

  echo ClamAV installed sucessfully
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_Clamav   # calling function
