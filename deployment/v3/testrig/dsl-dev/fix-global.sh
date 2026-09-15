#!/bin/bash
# Fix missing configmap "global" in dsl-dev (common cause of Failed: configmap "global" not found).
## Usage: ./fix-global.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=dsl-dev
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Copying configmaps into $NS (includes global from default)..."
./copy_cm.sh

if ! kubectl -n "$NS" get cm global >/dev/null 2>&1; then
  API_INTERNAL_HOST=$(kubectl -n default get cm global -o json | jq -r '.data."mosip-api-internal-host"')
  echo "Creating minimal global configmap in $NS"
  kubectl -n "$NS" create cm global --from-literal="mosip-api-internal-host=$API_INTERNAL_HOST"
fi

echo "Configmaps in $NS:"
kubectl -n "$NS" get cm

echo "Delete failed/incomplete jobs so a new run can start cleanly:"
echo "  kubectl -n $NS delete job --all"
echo "Then re-trigger from the cronjob, e.g.:"
echo "  kubectl -n $NS create job --from=cronjob/<cronjob-name> dsl-dev-manual-\$(date +%s)"
