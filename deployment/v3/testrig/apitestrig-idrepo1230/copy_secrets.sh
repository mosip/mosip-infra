#!/bin/bash
# Copy secrets from other namespaces
# DST_NS: Destination namespace

function copying_secrets() {
  COPY_UTIL=../../utils/copy_cm_func.sh
  DST_NS=${NS:-apitestrig1230}
  $COPY_UTIL secret keycloak-client-secrets keycloak $DST_NS
  $COPY_UTIL secret s3 s3 $DST_NS
  $COPY_UTIL secret postgres-postgresql postgres $DST_NS
  return 0
}

set -e
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
copying_secrets
