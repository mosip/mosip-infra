#!/bin/bash
# Installs resident service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=resident
CHART_VERSION=12.0.1-B3
MIMOTO_CHART_VERSION=0.9
RESIDENT_UI_CHART_VERSION=0.0.1

echo Create $NS namespace
kubectl create ns $NS

function installing_resident() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  echo Copy secrets
  sed -i 's/\r$//' copy_secrets.sh
  ./copy_secrets.sh

  API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  RESIDENT_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-resident-host})

  echo Installing Resident
  helm -n $NS install resident mosip/resident --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$RESIDENT_HOST --version $CHART_VERSION

  echo Installing mimoto
  helm -n $NS install mimoto mosip/mimoto --version $MIMOTO_CHART_VERSION

  echo Installing Resident UI
  helm -n $NS install resident-ui mosip/resident-ui --set resident.apiHost=$API_HOST --set istio.hosts\[0\]=$RESIDENT_HOST --version $RESIDENT_UI_CHART_VERSION

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed Resident services
  echo Installed mimoto
  echo Installed Resident UI


  echo "resident-ui portal URL: https://$RESIDENT_HOST/"
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_resident   # calling function
