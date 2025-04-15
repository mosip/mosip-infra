#!/bin/bash
NS=mosip-file-server

function installing_mfs() {

  kubectl -n $NS --ignore-not-found=true delete secret keycloak-client-secret

  KEYCLOAK_CLIENT_SECRET=$(kubectl -n keycloak get secrets keycloak-client-secrets -o yaml | awk '/mosip_regproc_client_secret: /{print $2}' | base64 -d)
  kubectl create secret generic keycloak-client-secret \
  --namespace=$NS \
  --from-literal=KEYCLOAK_CLIENT_SECRET=$KEYCLOAK_CLIENT_SECRET
  #--annotations="meta.helm.sh/release-name=mosip-file-server,meta.helm.sh/release-namespace=mosip-file-server"

  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_mfs   # calling function
