#!/bin/bash
# Copy secrets from other namespaces
# Only the Postgres superuser credential is copied here. The Keycloak DB
# user gets its own dedicated password (generated in install.sh), never the
# shared db-common-secrets value used by other MOSIP module DB users.

function copying_secrets() {
  COPY_UTIL=../../utils/copy_cm_func.sh
  DST_NS=keycloak

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
