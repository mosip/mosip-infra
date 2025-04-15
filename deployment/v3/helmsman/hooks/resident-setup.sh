#!/bin/bash

NS=resident

function installing_resident() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  echo Copying Resorces
  COPY_UTIL=../utils/copy-cm-and-secrets/copy_cm_func.sh
  #Copy configmaps
  $COPY_UTIL configmap global default $NS
  $COPY_UTIL configmap artifactory-share artifactory $NS
  $COPY_UTIL configmap config-server-share config-server $NS
  #Copy Secrets
  $COPY_UTIL secret keycloak-client-secrets keycloak $NS

  echo Setting up dummy values for Resident OIDC Client ID
  kubectl create secret generic resident-oidc-onboarder-key -n $NS --from-literal=resident-oidc-clientid='' --dry-run=client -o yaml | kubectl apply -f -
  $COPY_UTIL secret resident-oidc-onboarder-key resident config-server

  kubectl -n config-server set env --keys=resident-oidc-clientid --from secret/resident-oidc-onboarder-key deployment/config-server --prefix=SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_
  kubectl -n config-server get deploy -o name | xargs -n1 -t kubectl -n config-server rollout status

  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_resident   # calling function
