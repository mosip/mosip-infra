#!/bin/bash
# Deploy uitestrig for the MOSIP "dev" environment (*.dev.mosip.net).
# Non-interactive: values are taken from env vars / defaults that match
# mosip/infra Helmsman DSF on branch `dev`.
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
VALUES_FILE="$SCRIPT_DIR/values.yaml"
COPY_UTIL="$INFRA_ROOT/utils/copy_cm_func.sh"

NS=uitestrig
DOMAIN_NAME="${DOMAIN_NAME:-dev.mosip.net}"
ENV_NAME="${ENV_NAME:-dev}"
CHART_VERSION="${CHART_VERSION:-12.0.2}"
CRON_HOUR="${CRON_HOUR:-3}"
DB_PORT="${DB_PORT:-5433}"
ENABLE_INSECURE="${ENABLE_INSECURE:-false}"
USE_LOCAL_VALUES="${USE_LOCAL_VALUES:-true}"

API_INTERNAL_HOST="${API_INTERNAL_HOST:-api-internal.${DOMAIN_NAME}}"
ADMIN_HOST="${ADMIN_HOST:-admin.${DOMAIN_NAME}}"
PMP_HOST="${PMP_HOST:-pmp.${DOMAIN_NAME}}"
RESIDENT_HOST="${RESIDENT_HOST:-resident.${DOMAIN_NAME}}"
INJI_WEB_HOST="${INJI_WEB_HOST:-injiweb.${DOMAIN_NAME}}"
INJI_VERIFY_HOST="${INJI_VERIFY_HOST:-injiverify.${DOMAIN_NAME}}"
ESIGNET_HOST="${ESIGNET_HOST:-esignet.${DOMAIN_NAME}}"

# Optional extended keys used by chart 1.6.x (ignored harmlessly by 12.0.x if unused)
ENV_URL="${ENV_URL:-https://${INJI_WEB_HOST}/}"
INJI_WEB_UI="${INJI_WEB_UI:-https://${INJI_WEB_HOST}/}"
TEST_URL="${TEST_URL:-}"
ENV_USER="${ENV_USER:-api-internal.${ENV_NAME}}"
MOSIP_INJIWEB_GOOGLE_REFRESH_TOKEN="${MOSIP_INJIWEB_GOOGLE_REFRESH_TOKEN:-}"
MOSIP_INJIWEB_GOOGLE_CLIENT_ID="${MOSIP_INJIWEB_GOOGLE_CLIENT_ID:-}"
MOSIP_INJIWEB_GOOGLE_CLIENT_SECRET="${MOSIP_INJIWEB_GOOGLE_CLIENT_SECRET:-}"
BROWSERSTACK_USERNAME="${BROWSERSTACK_USERNAME:-}"
BROWSERSTACK_ACCESS_KEY="${BROWSERSTACK_ACCESS_KEY:-}"

function require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: $1 is required; EXITING."
    exit 1
  fi
}

function install_uitestrig() {
  echo "Create $NS namespace"
  kubectl create ns "$NS" --dry-run=client -o yaml | kubectl apply -f -

  echo "Istio label"
  kubectl label ns "$NS" istio-injection=disabled --overwrite

  helm repo add mosip https://mosip.github.io/mosip-helm 2>/dev/null || true
  helm repo update

  echo "Copy configmaps and secrets into $NS"
  kubectl -n "$NS" delete --ignore-not-found=true configmap s3
  kubectl -n "$NS" delete --ignore-not-found=true configmap db
  kubectl -n "$NS" delete --ignore-not-found=true configmap uitestrig
  "$COPY_UTIL" configmap global default "$NS"
  "$COPY_UTIL" configmap keycloak-host keycloak "$NS"
  "$COPY_UTIL" configmap artifactory-share artifactory "$NS"
  "$COPY_UTIL" configmap config-server-share config-server "$NS"
  "$COPY_UTIL" secret keycloak-client-secrets keycloak "$NS"
  "$COPY_UTIL" secret s3 s3 "$NS"
  "$COPY_UTIL" secret postgres-postgresql postgres "$NS"

  values_args=()
  if [[ "$USE_LOCAL_VALUES" == "true" && -f "$VALUES_FILE" ]]; then
    values_args+=(-f "$VALUES_FILE")
  fi

  insecure_flag=()
  if [[ "$ENABLE_INSECURE" == "true" ]]; then
    insecure_flag+=(--set enable_insecure=true)
    insecure_flag+=(--set uitestrig.configmaps.uitestrig.ENABLE_INSECURE=true)
  fi

  extra_sets=()
  if [[ -n "$TEST_URL" ]]; then
    extra_sets+=(--set "uitestrig.configmaps.uitestrig.TEST_URL=$TEST_URL")
  fi
  if [[ -n "$MOSIP_INJIWEB_GOOGLE_REFRESH_TOKEN" ]]; then
    extra_sets+=(--set "uitestrig.configmaps.uitestrig.MOSIP_INJIWEB_GOOGLE_REFRESH_TOKEN=$MOSIP_INJIWEB_GOOGLE_REFRESH_TOKEN")
  fi
  if [[ -n "$MOSIP_INJIWEB_GOOGLE_CLIENT_ID" ]]; then
    extra_sets+=(--set "uitestrig.configmaps.uitestrig.MOSIP_INJIWEB_GOOGLE_CLIENT_ID=$MOSIP_INJIWEB_GOOGLE_CLIENT_ID")
  fi
  if [[ -n "$MOSIP_INJIWEB_GOOGLE_CLIENT_SECRET" ]]; then
    extra_sets+=(--set "uitestrig.configmaps.uitestrig.MOSIP_INJIWEB_GOOGLE_CLIENT_SECRET=$MOSIP_INJIWEB_GOOGLE_CLIENT_SECRET")
  fi
  if [[ -n "$BROWSERSTACK_USERNAME" ]]; then
    extra_sets+=(--set "uitestrig.configmaps.uitestrig.BROWSERSTACK_USERNAME=$BROWSERSTACK_USERNAME")
  fi
  if [[ -n "$BROWSERSTACK_ACCESS_KEY" ]]; then
    extra_sets+=(--set "uitestrig.configmaps.uitestrig.BROWSERSTACK_ACCESS_KEY=$BROWSERSTACK_ACCESS_KEY")
  fi

  echo "Installing uitestrig (chart $CHART_VERSION) for domain $DOMAIN_NAME / env $ENV_NAME"
  helm -n "$NS" upgrade --install uitestrig mosip/uitestrig \
    --set "crontime=0 $CRON_HOUR * * *" \
    --version "$CHART_VERSION" \
    "${values_args[@]}" \
    --set uitestrig.configmaps.s3.s3-host='http://minio.minio:9000' \
    --set uitestrig.configmaps.s3.s3-user-key='admin' \
    --set uitestrig.configmaps.s3.s3-region='' \
    --set "uitestrig.configmaps.db.db-server=$API_INTERNAL_HOST" \
    --set uitestrig.configmaps.db.db-su-user="postgres" \
    --set "uitestrig.configmaps.db.db-port=$DB_PORT" \
    --set "uitestrig.configmaps.uitestrig.apiInternalEndPoint=https://$API_INTERNAL_HOST" \
    --set "uitestrig.configmaps.uitestrig.apiEnvUser=$API_INTERNAL_HOST" \
    --set "uitestrig.configmaps.uitestrig.PmpPortalPath=https://$PMP_HOST" \
    --set "uitestrig.configmaps.uitestrig.adminPortalPath=https://$ADMIN_HOST" \
    --set "uitestrig.configmaps.uitestrig.residentPortalPath=https://$RESIDENT_HOST" \
    --set "uitestrig.configmaps.uitestrig.verifyPortalPath=https://$INJI_VERIFY_HOST/" \
    --set "uitestrig.configmaps.uitestrig.NS=$NS" \
    --set "uitestrig.configmaps.uitestrig.env=$ENV_URL" \
    --set "uitestrig.configmaps.uitestrig.injiWebUi=$INJI_WEB_UI" \
    --set "uitestrig.configmaps.uitestrig.mosip_components_base_urls=auditmanager=$API_INTERNAL_HOST;idrepository=$API_INTERNAL_HOST;partnermanager=$API_INTERNAL_HOST;idauthentication=$API_INTERNAL_HOST;policymanager=$API_INTERNAL_HOST;authmanager=$API_INTERNAL_HOST;resident=$API_INTERNAL_HOST;preregistration=$API_INTERNAL_HOST;masterdata=$API_INTERNAL_HOST;idgenerator=$API_INTERNAL_HOST;" \
    --set "uitestrig.configmaps.uitestrig.mosip_inji_web_url=https://$INJI_WEB_HOST/" \
    --set "uitestrig.configmaps.uitestrig.injiweb=https://$INJI_WEB_HOST/issuers" \
    --set "uitestrig.configmaps.uitestrig.eSignetbaseurl=https://$ESIGNET_HOST" \
    --set "uitestrig.configmaps.uitestrig.injiverify=https://$INJI_VERIFY_HOST/" \
    --set "uitestrig.configmaps.uitestrig.ENV_ENDPOINT=https://$API_INTERNAL_HOST" \
    --set "uitestrig.configmaps.uitestrig.ENV_USER=$ENV_USER" \
    "${extra_sets[@]}" \
    "${insecure_flag[@]}"

  echo "Installed uitestrig in namespace $NS"
  kubectl -n "$NS" get cronjob,pods
}

require_command kubectl
require_command helm
require_command jq

install_uitestrig

echo "dev uitestrig deployment complete."
echo "Trigger a run manually with:"
echo "  kubectl --kubeconfig=\${KUBECONFIG:-} -n uitestrig create job --from=cronjob/cronjob-uitestrig cronjob-uitestrig-\$(date +%Y%m%d%H%M%S)"
