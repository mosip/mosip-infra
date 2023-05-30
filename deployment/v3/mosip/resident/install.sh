#!/bin/bash
# Installs resident service
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=resident
CHART_VERSION=12.0.1
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

  echo "Do you have public domain & valid SSL? (Y/n) "
  echo "Y: if you have public domain & valid ssl certificate"
  echo "n: If you don't have a public domain and a valid SSL certificate. Note: It is recommended to use this option only in development environments."
  read -p "" flag

  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set enable_insecure=true';
  fi

  API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  RESIDENT_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-resident-host})

  echo Installing Resident
  helm -n $NS install resident mosip/resident --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$RESIDENT_HOST --version $CHART_VERSION $ENABLE_INSECURE

  echo Installing mimoto
  helm -n $NS install mimoto mosip/mimoto --version $MIMOTO_CHART_VERSION $ENABLE_INSECURE

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
