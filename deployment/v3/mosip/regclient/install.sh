#!/bin/bash
# Installs regclient Downloader
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=regclient
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_regclient() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  REGCLIENT_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-regclient-host})
  INTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  HEALTH_URL=https://$INTERNAL_HOST/v1/syncdata/actuator/health

  echo Installing reg client downloader. This may take a few minutes ..
  helm -n $NS install regclient mosip/regclient \
    --set regclient.upgradeServerUrl=https://$REGCLIENT_HOST \
    --set regclient.healthCheckUrl=$HEALTH_URL \
    --set regclient.hostName=$INTERNAL_HOST \
    --set istio.host=$REGCLIENT_HOST \
    --wait \
    --version $CHART_VERSION

  echo Get your download url from here
  echo https://$REGCLIENT_HOST/
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_regclient   # calling function
