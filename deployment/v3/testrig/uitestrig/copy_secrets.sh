#!/bin/bash
# Copy secrets from other namespaces
# DST_NS: Destination namespace

function copying_secrets() {
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  COPY_UTIL="$SCRIPT_DIR/../../utils/copy_cm_func.sh"
  DST_NS=uitestrig

  if [ ! -x "$COPY_UTIL" ]; then
    UTIL_URL=https://raw.githubusercontent.com/mosip/mosip-infra/release-1.2.1.x/deployment/v3/utils/copy_cm_func.sh
    COPY_UTIL=./copy_cm_func.sh
    if ! wget -q "$UTIL_URL" -O copy_cm_func.sh; then
      echo "ERROR: Failed to find local copy_cm_func.sh and download from $UTIL_URL"
      exit 1
    fi
    chmod +x copy_cm_func.sh
  fi

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
