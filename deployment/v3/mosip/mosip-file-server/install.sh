#!/bin/bash
# Install mosip-file-server
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosip-file-server
CHART_VERSION=0.0.1-develop

echo Create $NS namespace
kubectl create ns $NS

function installing_mfs() {
  echo Istio label Disabled
  kubectl label ns $NS istio-injection=disabled --overwrite
  helm repo update

  echo Copy configmaps
  sed -i 's/\r$//' copy_cm.sh
  ./copy_cm.sh

  FILESERVER_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
  API_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
  API_INTERNAL_HOST=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  HEALTH_URL=https://$FILESERVER_HOST/.well-known/

  kubectl -n $NS --ignore-not-found=true delete configmap mosip-file-server
  kubectl -n $NS --ignore-not-found=true delete secret keycloak-client-secret
  KEYCLOAK_CLIENT_SECRET=$( kubectl -n keycloak get secrets keycloak-client-secrets -o yaml | awk '/mosip_regproc_client_secret: /{print $2}' | base64 -d )

  echo Install mosip-file-server. This may take a few minutes ..
  helm -n $NS install mosip-file-server mosip/mosip-file-server      \
    --set mosipfileserver.host=$FILESERVER_HOST                      \
    --set mosipfileserver.secrets.KEYCLOAK_CLIENT_SECRET="$KEYCLOAK_CLIENT_SECRET" \
    --set istio.corsPolicy.allowOrigins\[0\].prefix=https://$API_HOST \
    --set istio.corsPolicy.allowOrigins\[1\].prefix=https://$API_INTERNAL_HOST \
    --set istio.corsPolicy.allowOrigins\[2\].prefix=https://verifiablecredential.io \
    --wait                                                           \
    --version $CHART_VERSION

  echo Get your download url from here
  echo https://$FILESERVER_HOST/.well-known/
  echo https://$FILESERVER_HOST/inji/
  echo https://$FILESERVER_HOST/mosip-certs/
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_mfs   # calling function
