#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace

function copying_cm() {
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

  $COPY_UTIL configmap global default $DST_NS
  $COPY_UTIL configmap keycloak-host keycloak $DST_NS
  $COPY_UTIL configmap artifactory-share artifactory $DST_NS
  $COPY_UTIL configmap config-server-share config-server $DST_NS
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
copying_cm   # calling function
