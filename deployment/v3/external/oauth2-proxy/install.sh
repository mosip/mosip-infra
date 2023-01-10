#!/bin/bash

ROOT_DOMAIN=".mosip.net"

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi

if ! java -version > /dev/null 2> /dev/null; then
  echo "java is missing. Please install java"; exit 1;
fi

if ! jq --version > /dev/null 2> /dev/null; then
  echo "jq is missing. Please install jq"; exit 2;
fi

if ! [ -d "keycloak-15.0.2" ]; then
  echo "Downloading keycloak admin cli" && wget -q --show-progress "https://github.com/keycloak/keycloak/releases/download/15.0.2/keycloak-15.0.2.zip" &&
  echo "Download Success. Unzipping.." && unzip -q "keycloak-15.0.2.zip" &&
  rm "keycloak-15.0.2.zip" > /dev/null
fi

KCADM_SH="./keycloak-15.0.2/bin/kcadm.sh"
KCADM_CFG="$KCADM_SH.config"

INSTALLATION_NAME=$(kubectl get cm global -ojsonpath={.data.installation-name})
read -p "Current installation name (default: $INSTALLATION_NAME) : " TO_REPLACE
INSTALLATION_NAME=${TO_REPLACE:-$INSTALLATION_NAME}
unset TO_REPLACE

IAM_HOST=$(kubectl get cm keycloak-host -n keycloak -ojsonpath={.data.keycloak-host})
read -p "Keycloak host name (default: $IAM_HOST) : " TO_REPLACE
IAM_HOST=${TO_REPLACE:-$IAM_HOST}
unset TO_REPLACE

IAM_ADMIN_PASS=$(kubectl get secret keycloak -n keycloak -ojsonpath={.data.admin-password} | base64 --decode)
read -p "Keycloak admin password (leave empty to take from secret) : " TO_REPLACE
IAM_HOST=${TO_REPLACE:-$IAM_HOST}
unset TO_REPLACE

echo "Creating Keycloak Realm, Istio. And the required client and roles"
$KCADM_SH config credentials --server https://$IAM_HOST/auth --realm master --user admin --password $IAM_ADMIN_PASS --config $KCADM_CFG
$KCADM_SH create realms -s realm=istio -s enabled=true --config $KCADM_CFG; if [ $? -ne 0 ]; then echo "Realm Already Exists. Please delete it."; exit 3; fi
realm_create_output=$($KCADM_SH create partialImport -r istio -s ifResourceExists=SKIP -o -f istio-realm.json --config $KCADM_CFG)

istio_client_id="istio-auth-client"
istio_client_id_ID=$(echo $realm_create_output | jq '.results' | jq ".[] | select(.resourceName==\"$istio_client_id\")" | jq -r '.id')
$KCADM_SH create clients/$istio_client_id_ID/client-secret -r istio --config $KCADM_CFG
istio_client_secret=$($KCADM_SH get clients/$istio_client_id_ID/client-secret -r istio --config $KCADM_CFG | jq -r '.value')

TEMP_MANIFEST=./.manifest.yaml.tmp
cp oauth2-proxy.yaml $TEMP_MANIFEST

sed -i "s/___ISTIO_CLIENT_ID___/$istio_client_id/g" $TEMP_MANIFEST
sed -i "s/___ISTIO_CLIENT_SECRET___/$istio_client_secret/g" $TEMP_MANIFEST
sed -i "s/___IAM_HOST___/$IAM_HOST/g" $TEMP_MANIFEST
sed -i "s/___ROOT_DOMAIN___/$ROOT_DOMAIN/g" $TEMP_MANIFEST
sed -i "s/___INSTALLATION_NAME___/$INSTALLATION_NAME/g" $TEMP_MANIFEST

NS=oauth2-proxy

echo Creating namespace
kubectl create ns $NS

function installing_oauth2_proxy() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  echo Installing
  kubectl apply -f $TEMP_MANIFEST -n $NS
  #helm -n $NS install oauth2-proxy bitnami/oauth2-proxy -f values-oauth2-proxy.yaml --set configuration.clientID=$istio_client_id --set configuration.clientSecret=$istio_client_secret
  #helm -n $NS install oauth2-proxy bitnami/oauth2-proxy -f values-oauth2-proxy.yaml

  rm $TEMP_MANIFEST $KCADM_CFG
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_oauth2_proxy   # calling function