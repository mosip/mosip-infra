#!/bin/bash

NS=oauth2-proxy

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi

if [ -z "$INSTALLATION_NAME" ]; then
  INSTALLATION_NAME=$(kubectl get cm global -ojsonpath={.data.installation-name})
  read -p "Current installation name (default: $INSTALLATION_NAME) : " TO_REPLACE
  INSTALLATION_NAME=${TO_REPLACE:-$INSTALLATION_NAME}
  unset TO_REPLACE
fi

if [ -z "$IAM_HOST" ]; then
  IAM_HOST=$(kubectl get cm keycloak-host -n keycloak -ojsonpath={.data.keycloak-external-host})
  read -p "Keycloak host name (default: $IAM_HOST) : " TO_REPLACE
  IAM_HOST=${TO_REPLACE:-$IAM_HOST}
  unset TO_REPLACE
fi

if [ -z "$istio_client_id" ]; then
  istio_client_id="istio-auth-client"
  read -p "Keycloak istio auth client name (default: $istio_client_id) : " TO_REPLACE
  istio_client_id=${TO_REPLACE:-$istio_client_id}
  unset TO_REPLACE
fi

if [ -z "$istio_client_secret" ]; then
  read -p "Keycloak istio auth client secret : " istio_client_secret
  if [ -z "$istio_client_secret" ]; then
    exit "Give valid client secret."
  fi
fi

if [ -z "$ROOT_DOMAIN" ]; then
  ROOT_DOMAIN=".mosip.net"
  read -p "Root Domain for oauth2-proxy cookie (default: $ROOT_DOMAIN) : " TO_REPLACE
  ROOT_DOMAIN=${TO_REPLACE:-$ROOT_DOMAIN}
  unset TO_REPLACE
fi

TEMP_MANIFEST=./.manifest.yaml.tmp
cp oauth2-proxy.yaml $TEMP_MANIFEST

cookie_secret=$(dd if=/dev/urandom bs=32 count=1 2>/dev/null | base64 | tr -d -- '\n' | tr -- '+/' '-_' | base64)

sed -i "s/___ISTIO_CLIENT_ID___/$istio_client_id/g" $TEMP_MANIFEST
sed -i "s/___ISTIO_CLIENT_SECRET___/$istio_client_secret/g" $TEMP_MANIFEST
sed -i "s/___IAM_HOST___/$IAM_HOST/g" $TEMP_MANIFEST
sed -i "s/___ROOT_DOMAIN___/$ROOT_DOMAIN/g" $TEMP_MANIFEST
sed -i "s/___INSTALLATION_NAME___/$INSTALLATION_NAME/g" $TEMP_MANIFEST
sed -i "s/___COOKIE_SECRET___/$cookie_secret/g" $TEMP_MANIFEST

echo Creating namespace
kubectl create ns $NS

function installing_oauth2_proxy() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  echo Installing
  kubectl apply -f $TEMP_MANIFEST -n $NS
  #helm -n $NS install oauth2-proxy bitnami/oauth2-proxy -f values-oauth2-proxy.yaml --set configuration.clientID=$istio_client_id --set configuration.clientSecret=$istio_client_secret
  #helm -n $NS install oauth2-proxy bitnami/oauth2-proxy -f values-oauth2-proxy.yaml

  rm $TEMP_MANIFEST
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_oauth2_proxy   # calling function