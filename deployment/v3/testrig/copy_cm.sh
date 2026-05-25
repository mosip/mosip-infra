#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace 
UTIL_URL=https://raw.githubusercontent.com/mosip/mosip-infra/41afdf43de426591b296407c98bf6305e3e106bc/deployment/v3/utils/copy_cm_func.sh
COPY_UTIL=./copy_cm_func.sh
DST_NS=uitestrig

#!/bin/bash
# Copy configmaps from other namespaces
# DST_NS: Destination namespace
set -euo pipefail

UTIL_URL=https://raw.githubusercontent.com/mosip/mosip-infra/41afdf43de426591b296407c98bf6305e3e106bc/deployment/v3/utils/copy_cm_func.sh
COPY_UTIL=./copy_cm_func.sh
DST_NS=uitestrig

if ! wget -q "$UTIL_URL" -O copy_cm_func.sh; then
  echo "ERROR: Failed to download copy_cm_func.sh from $UTIL_URL"
  exit 1
fi
chmod +x copy_cm_func.sh
trap 'rm -f copy_cm_func.sh' EXIT

$COPY_UTIL configmap global default $DST_NS
$COPY_UTIL configmap keycloak-host keycloak $DST_NS
$COPY_UTIL configmap artifactory-share artifactory $DST_NS
$COPY_UTIL configmap config-server-share config-server $DST_NS
