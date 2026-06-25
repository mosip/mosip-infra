#!/bin/bash
# Deploy packetcreator and dslrig for qajava21 environment (dev space).
# Both services read domain values from the global configmap in the default namespace.
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi

set -e
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INFRA_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
GLOBAL_CM="$INFRA_ROOT/external/global_configmap.qajava21-dev.yaml"

PACKETCREATOR_NS=packetcreator
DSLRIG_NS=dslrig
CHART_VERSION="${CHART_VERSION:-1.4.0}"
CRON_HOUR="${CRON_HOUR:-4}"
REPORT_RETENTION_DAYS="${REPORT_RETENTION_DAYS:-3}"
PACKET_UTILITY_BASE_URL="${PACKET_UTILITY_BASE_URL:-http://packetcreator.packetcreator:80/v1/packetcreator}"
ENABLE_INSECURE="${ENABLE_INSECURE:-true}"

function require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: $1 is required; EXITING."
    exit 1
  fi
}

function apply_global_configmap() {
  echo "Applying global configmap (dev space) to default namespace..."
  kubectl apply -f "$GLOBAL_CM"
  kubectl -n default get cm global -o jsonpath='{.data.installation-name}{" / "}{.data.installation-domain}{"\n"}'
}

function install_packetcreator() {
  echo "Create $PACKETCREATOR_NS namespace"
  kubectl create ns "$PACKETCREATOR_NS" --dry-run=client -o yaml | kubectl apply -f -

  echo "Istio label"
  kubectl label ns "$PACKETCREATOR_NS" istio-injection=enabled --overwrite

  api_internal_host=$(kubectl -n default get cm global -o json | jq -rc '.data."mosip-api-internal-host"')
  if [[ -z "$api_internal_host" || "$api_internal_host" == "null" ]]; then
    echo "ERROR: mosip-api-internal-host missing in default/global configmap; EXITING."
    exit 1
  fi
  kubectl -n "$PACKETCREATOR_NS" create cm global \
    --from-literal="mosip-api-internal-host=$api_internal_host" \
    --dry-run=client -o yaml | kubectl apply -f -

  helm repo add mosip https://mosip.github.io/mosip-helm 2>/dev/null || true
  helm repo update

  insecure_flag=""
  if [[ "$ENABLE_INSECURE" == "true" ]]; then
    insecure_flag="--set enable_insecure=true"
  fi

  echo "Installing packetcreator"
  helm -n "$PACKETCREATOR_NS" upgrade --install packetcreator mosip/packetcreator \
    --set istio.enabled=true \
    --set ingress.enabled=false \
    --wait --version "$CHART_VERSION" \
    $insecure_flag
  echo "Installed packetcreator."
}

function install_dslrig() {
  echo "Create $DSLRIG_NS namespace"
  kubectl create ns "$DSLRIG_NS" --dry-run=client -o yaml | kubectl apply -f -

  echo "Istio label"
  kubectl label ns "$DSLRIG_NS" istio-injection=disabled --overwrite

  COPY_UTIL="$INFRA_ROOT/utils/copy_cm_func.sh"
  echo "Copy configmaps from default namespace"
  kubectl -n "$DSLRIG_NS" delete --ignore-not-found=true configmap s3
  kubectl -n "$DSLRIG_NS" delete --ignore-not-found=true configmap db
  kubectl -n "$DSLRIG_NS" delete --ignore-not-found=true configmap dslrig
  "$COPY_UTIL" configmap global default "$DSLRIG_NS"
  "$COPY_UTIL" configmap keycloak-host keycloak "$DSLRIG_NS"
  "$COPY_UTIL" configmap artifactory-share artifactory "$DSLRIG_NS"
  "$COPY_UTIL" configmap config-server-share config-server "$DSLRIG_NS"

  echo "Copy secrets"
  "$COPY_UTIL" secret keycloak-client-secrets keycloak "$DSLRIG_NS"
  "$COPY_UTIL" secret s3 s3 "$DSLRIG_NS"
  "$COPY_UTIL" secret postgres-postgresql postgres "$DSLRIG_NS"

  DB_HOST=$(kubectl -n default get cm global -o json | jq -r '.data."mosip-api-internal-host"')
  API_INTERNAL_HOST=$(kubectl -n default get cm global -o json | jq -r '.data."mosip-api-internal-host"')
  USER=$(kubectl -n default get cm global -o json | jq -r '.data."mosip-api-internal-host"')

  insecure_flag=""
  if [[ "$ENABLE_INSECURE" == "true" ]]; then
    insecure_flag="--set enable_insecure=true"
  fi

  echo "Installing dslorchestrator"
  helm -n "$DSLRIG_NS" upgrade --install dslorchestrator mosip/dslorchestrator \
    --set crontime="0 $CRON_HOUR * * *" \
    --version "$CHART_VERSION" \
    --set dslorchestrator.configmaps.s3.s3-host='http://minio.minio:9000' \
    --set dslorchestrator.configmaps.s3.s3-user-key='admin' \
    --set dslorchestrator.configmaps.s3.s3-region='' \
    --set dslorchestrator.configmaps.db.db-server="$DB_HOST" \
    --set dslorchestrator.configmaps.db.db-su-user="postgres" \
    --set dslorchestrator.configmaps.db.db-port="5432" \
    --set dslorchestrator.configmaps.dslorchestrator.USER="$USER" \
    --set dslorchestrator.configmaps.dslorchestrator.ENDPOINT="https://$API_INTERNAL_HOST" \
    --set dslorchestrator.configmaps.dslorchestrator.packetUtilityBaseUrl="$PACKET_UTILITY_BASE_URL" \
    --set dslorchestrator.configmaps.dslorchestrator.reportExpirationInDays="$REPORT_RETENTION_DAYS" \
    --set dslorchestrator.configmaps.dslorchestrator.NS="$DSLRIG_NS" \
    --set dslorchestrator.configmaps.dslorchestrator.threadCount="8" \
    $insecure_flag
  echo "Installed dslrig."
}

require_command kubectl
require_command helm
require_command jq

apply_global_configmap
install_packetcreator
install_dslrig

echo "qajava21 dev testrig deployment complete."
echo "Packetcreator and dslrig both use global configmap from default namespace."
