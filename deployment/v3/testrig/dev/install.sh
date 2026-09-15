#!/bin/bash
# Deploy packetcreator and dslrig into a dedicated "dev" namespace (not packetcreator/dslrig).
# Domain values are copied from the global configmap in default (default is not modified).
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

TARGET_NS="${TARGET_NS:-dev}"
CHART_VERSION="${CHART_VERSION:-0.0.1-develop}"
PACKETCREATOR_IMAGE_REPO="${PACKETCREATOR_IMAGE_REPO:-mosipdev/dsl-packetcreator}"
PACKETCREATOR_IMAGE_TAG="${PACKETCREATOR_IMAGE_TAG:-develop}"
DSLORCHESTRATOR_IMAGE_REPO="${DSLORCHESTRATOR_IMAGE_REPO:-mosipdev/dsl-orchestrator}"
DSLORCHESTRATOR_IMAGE_TAG="${DSLORCHESTRATOR_IMAGE_TAG:-develop}"
CRON_HOUR="${CRON_HOUR:-4}"
REPORT_RETENTION_DAYS="${REPORT_RETENTION_DAYS:-3}"
PACKET_UTILITY_BASE_URL="${PACKET_UTILITY_BASE_URL:-http://packetcreator.${TARGET_NS}:80/v1/packetcreator}"
ENABLE_INSECURE="${ENABLE_INSECURE:-true}"
DB_PORT="${DB_PORT:-5433}"
THREAD_COUNT="${THREAD_COUNT:-2}"
ESIGNET_DEPLOYED="${ESIGNET_DEPLOYED:-no}"
SERVICES_NOT_DEPLOYED="${SERVICES_NOT_DEPLOYED:-esignet}"
INSTALLATION_NAME="${INSTALLATION_NAME:-dev}"

function require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: $1 is required; EXITING."
    exit 1
  fi
}

function require_default_global() {
  if ! kubectl -n default get cm global >/dev/null 2>&1; then
    echo "ERROR: configmap global must exist in namespace default; EXITING."
    exit 1
  fi
  kubectl -n default get cm global -o jsonpath='default/global: {.data.installation-domain}{"\n"}'
}

function prepare_target_namespace() {
  COPY_UTIL="$INFRA_ROOT/utils/copy_cm_func.sh"

  echo "Create namespace $TARGET_NS"
  kubectl create ns "$TARGET_NS" --dry-run=client -o yaml | kubectl apply -f -

  echo "Istio label (packetcreator expects injection enabled)"
  kubectl label ns "$TARGET_NS" istio-injection=enabled --overwrite

  echo "Copy global configmap from default into $TARGET_NS"
  "$COPY_UTIL" configmap global default "$TARGET_NS"
  kubectl -n "$TARGET_NS" patch cm global --type merge \
    -p "{\"data\":{\"installation-name\":\"$INSTALLATION_NAME\"}}"

  echo "Copy configmaps and secrets required by dslorchestrator"
  kubectl -n "$TARGET_NS" delete --ignore-not-found=true configmap s3
  kubectl -n "$TARGET_NS" delete --ignore-not-found=true configmap db
  kubectl -n "$TARGET_NS" delete --ignore-not-found=true configmap dslrig
  "$COPY_UTIL" configmap keycloak-host keycloak "$TARGET_NS"
  "$COPY_UTIL" configmap artifactory-share artifactory "$TARGET_NS"
  "$COPY_UTIL" configmap config-server-share config-server "$TARGET_NS"
  "$COPY_UTIL" secret keycloak-client-secrets keycloak "$TARGET_NS"
  "$COPY_UTIL" secret s3 s3 "$TARGET_NS"
  "$COPY_UTIL" secret postgres-postgresql postgres "$TARGET_NS"

  kubectl -n "$TARGET_NS" get cm global -o jsonpath='{"'"$TARGET_NS"'/global: installation-name="}{.data.installation-name}{" domain="}{.data.installation-domain}{"\n"}'
}

function install_packetcreator() {
  helm repo add mosip https://mosip.github.io/mosip-helm 2>/dev/null || true
  helm repo update

  insecure_flag=""
  if [[ "$ENABLE_INSECURE" == "true" ]]; then
    insecure_flag="--set enable_insecure=true"
  fi

  echo "Installing packetcreator in namespace $TARGET_NS"
  helm -n "$TARGET_NS" upgrade --install packetcreator mosip/packetcreator \
    --set istio.enabled=true \
    --set ingress.enabled=false \
    --set image.repository="$PACKETCREATOR_IMAGE_REPO" \
    --set image.tag="$PACKETCREATOR_IMAGE_TAG" \
    --wait --version "$CHART_VERSION" \
    $insecure_flag
  echo "Installed packetcreator."
}

function install_dslrig() {
  DB_HOST=$(kubectl -n "$TARGET_NS" get cm global -o json | jq -r '.data."mosip-api-internal-host"')
  API_INTERNAL_HOST=$(kubectl -n "$TARGET_NS" get cm global -o json | jq -r '.data."mosip-api-internal-host"')
  USER=$(kubectl -n "$TARGET_NS" get cm global -o json | jq -r '.data."mosip-api-internal-host"')

  insecure_flag=""
  if [[ "$ENABLE_INSECURE" == "true" ]]; then
    insecure_flag="--set enable_insecure=true"
  fi

  echo "Installing dslorchestrator in namespace $TARGET_NS"
  helm -n "$TARGET_NS" upgrade --install dslorchestrator mosip/dslorchestrator \
    --set image.repository="$DSLORCHESTRATOR_IMAGE_REPO" \
    --set image.tag="$DSLORCHESTRATOR_IMAGE_TAG" \
    --set crontime="0 $CRON_HOUR * * *" \
    --version "$CHART_VERSION" \
    --set dslorchestrator.configmaps.s3.s3-host='http://minio.minio:9000' \
    --set dslorchestrator.configmaps.s3.s3-user-key='admin' \
    --set dslorchestrator.configmaps.s3.s3-region='' \
    --set dslorchestrator.configmaps.db.db-server="$DB_HOST" \
    --set dslorchestrator.configmaps.db.db-su-user="postgres" \
    --set dslorchestrator.configmaps.db.db-port="$DB_PORT" \
    --set dslorchestrator.configmaps.dslorchestrator.USER="$USER" \
    --set dslorchestrator.configmaps.dslorchestrator.ENDPOINT="https://$API_INTERNAL_HOST" \
    --set dslorchestrator.configmaps.dslorchestrator.packetUtilityBaseUrl="$PACKET_UTILITY_BASE_URL" \
    --set dslorchestrator.configmaps.dslorchestrator.reportExpirationInDays="$REPORT_RETENTION_DAYS" \
    --set dslorchestrator.configmaps.dslorchestrator.NS="$TARGET_NS" \
    --set dslorchestrator.configmaps.dslorchestrator.threadCount="$THREAD_COUNT" \
    --set dslorchestrator.configmaps.dslorchestrator.eSignetDeployed="$ESIGNET_DEPLOYED" \
    --set dslorchestrator.configmaps.dslorchestrator.servicesNotDeployed="$SERVICES_NOT_DEPLOYED" \
    $insecure_flag
  echo "Installed dslorchestrator."
}

require_command kubectl
require_command helm
require_command jq

require_default_global
prepare_target_namespace
install_packetcreator
install_dslrig

echo "Testrig deployment complete in namespace $TARGET_NS."
echo "default/global was left unchanged; $TARGET_NS/global carries installation-name=$INSTALLATION_NAME."
