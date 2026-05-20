#!/bin/bash
# Installs packetcreator
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=packetcreator
CHART_VERSION=1.3.0

echo Create $NS namespace
kubectl create ns $NS

function installing_packetcreator() {

  echo "Select the type of Ingress controller to be used (1/2): ";
  echo "1. Ingress";
  echo "2. Istio";
  read -p "" choice

  if [ $choice = "1" ]; then
    read -p "Please provide packetcreator host : " PACKETCREATOR_HOST

    if [ -z $PACKETCREATOR_HOST ]; then
      echo "PACKETCREATOR_HOST not provided; EXITING;"
      exit 1;
    fi
    list="--set ingress.enabled=true --set istio.enabled=false --set ingress.host=$PACKETCREATOR_HOST";
  fi

  if [ $choice = "2" ]; then
    list='--set istio.enabled=true --set ingress.enabled=false';

    echo Istio label
    kubectl label ns $NS istio-injection=enabled --overwrite
    helm repo update
  fi

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

  api_internal_host=$( kubectl -n default get cm global -o json | jq -rc '.data."mosip-api-internal-host"' )

  if [[ $api_internal_host = "null" ]]; then
    read -p "Please provide mosip-api-internal-host " api_internal_host
    kubectl -n $NS create cm global --from-literal="mosip-api-internal-host"="$api_internal_host"
  fi

  echo Installing packetcreator
  helm -n $NS install packetcreator mosip/packetcreator \
  $( echo $list ) \
  --wait --version $CHART_VERSION $ENABLE_INSECURE
  echo Installed packetcreator.
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_packetcreator   # calling function
