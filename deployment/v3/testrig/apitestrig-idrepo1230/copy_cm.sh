#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace

function copying_cm() {
  COPY_UTIL=../../utils/copy_cm_func.sh
  DST_NS=apitestrig
  $COPY_UTIL configmap global default $DST_NS
  $COPY_UTIL configmap keycloak-host keycloak $DST_NS
  $COPY_UTIL configmap artifactory-share artifactory $DST_NS
  $COPY_UTIL configmap config-server-share config-server $DST_NS
  return 0
}

set -e
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
copying_cm
