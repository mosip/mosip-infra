#!/bin/bash
# Copy secrets from other namespaces
# DST_NS: Destination namespace

function copying_secrets() {
  UTIL_URL=https://raw.githubusercontent.com/mosip/mosip-infra/41afdf43de426591b296407c98bf6305e3e106bc/deployment/v3/utils/copy_cm_func.sh
  COPY_UTIL=./copy_cm_func.sh
  DST_NS=apitestrig

  if ! wget -q "$UTIL_URL" -O copy_cm_func.sh; then
    echo "ERROR: Failed to download copy_cm_func.sh from $UTIL_URL"
    exit 1
  fi
  chmod +x copy_cm_func.sh

  $COPY_UTIL secret keycloak-client-secrets keycloak $DST_NS
  $COPY_UTIL secret s3 s3 $DST_NS
  $COPY_UTIL secret postgres-postgresql postgres $DST_NS
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
copying_secrets   # calling function