#!/bin/bash
# Installs Softhsm for Kernel and IDA
## Usage: ./install.sh [kubeconfig]


if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=softhsm
CHART_VERSION=1.3.0

echo Create $NS namespaces
kubectl create ns $NS

function installing_softhsm() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Installing Softhsm for Kernel
  helm -n $NS install softhsm-kernel mosip/softhsm -f values.yaml --version $CHART_VERSION --wait
  echo Installed Softhsm for Kernel

  echo Installing Softhsm for IDA
  helm -n $NS install softhsm-ida mosip/softhsm -f values.yaml --version $CHART_VERSION --wait
  echo Installed Softhsm for IDA
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_softhsm   # calling function
