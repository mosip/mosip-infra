#!/bin/bash
# Installs keymanager
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=keymanager
CHART_VERSION=12.0.1-B2

echo Creating $NS namespace
kubectl create ns $NS

function installing_keymanager() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  kubectl apply -n $NS -f idle_timeout_envoyfilter.yaml
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Running keygenerator. This may take a few minutes..
  helm -n $NS install kernel-keygen mosip/keygen --wait --wait-for-jobs --version $CHART_VERSION -f keygen_values.yaml

  echo Installing keymanager
  helm -n $NS install keymanager mosip/keymanager --version $CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status
  echo Installed keymanager services
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_keymanager   # calling function