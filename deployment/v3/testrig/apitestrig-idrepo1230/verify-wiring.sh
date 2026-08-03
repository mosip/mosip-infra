#!/bin/bash
# Verify idrepo1230 in-cluster service URLs and DB wiring.
# Root cause of "mosip_credential1230 stuck at 1 row": identity1230 still calling
# default http://credentialrequest.idrepo (old NS) → writes go to mosip_credential.
## Usage: ./verify-wiring.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=${NS:-idrepo1230}
OVERRIDES_CM=${OVERRIDES_CM:-idrepo1230-overrides}
EXPECTED_CREDREQUEST_URL=${EXPECTED_CREDREQUEST_URL:-http://credentialrequest1230.idrepo1230}
EXPECTED_CREDENTIAL_URL=${EXPECTED_CREDENTIAL_URL:-http://credential1230.idrepo1230}
EXPECTED_IDENTITY_URL=${EXPECTED_IDENTITY_URL:-http://identity1230.idrepo1230}
EXPECTED_VID_URL=${EXPECTED_VID_URL:-http://vid1230.idrepo1230}

set -euo pipefail

echo "=== 1) Overrides ConfigMap ($NS/$OVERRIDES_CM) ==="
if ! kubectl -n "$NS" get cm "$OVERRIDES_CM" >/dev/null 2>&1; then
  echo "MISSING: ConfigMap $OVERRIDES_CM in $NS"
  echo "Create it with correct service names (*1230), then remount on all 4 deploys."
  exit 1
fi

kubectl -n "$NS" get cm "$OVERRIDES_CM" -o json | jq -r '
  .data
  | to_entries[]
  | select(.key | test("URL$|url$|IDENTITY|VID|CRED"))
  | "\(.key)=\(.value)"
'

echo
echo "=== 2) envFrom on each deploy (must list $OVERRIDES_CM) ==="
for dep in identity1230 vid1230 credential1230 credentialrequest1230; do
  echo "--- $dep ---"
  if ! kubectl -n "$NS" get deploy "$dep" >/dev/null 2>&1; then
    echo "MISSING deploy $dep"
    continue
  fi
  kubectl -n "$NS" get deploy "$dep" -o jsonpath='{range .spec.template.spec.containers[0].envFrom[*].configMapRef}{.name}{"\n"}{end}'
done

echo
echo "=== 3) Effective URL env on identity1230 (must be *1230 hosts) ==="
echo "Expected:"
echo "  MOSIP_IDREPO_CREDREQUEST_GENERATOR_URL / override → $EXPECTED_CREDREQUEST_URL"
echo "  MOSIP_IDREPO_CREDENTIAL_SERVICE_URL / override → $EXPECTED_CREDENTIAL_URL"
kubectl -n "$NS" exec deploy/identity1230 -- printenv 2>/dev/null | grep -E 'CREDREQUEST|CREDENTIAL_SERVICE|IDENTITY_URL|VID_URL|IDREPO_' || true

echo
echo "=== 3b) SPRING_APPLICATION_JSON on identity1230 (must contain credentialrequest1230) ==="
kubectl -n "$NS" exec deploy/identity1230 -- printenv SPRING_APPLICATION_JSON 2>/dev/null \
  | jq -r '
      ."mosip.idrepo.credential.request.rest.uri",
      ."mosip.idrepo.credrequest.generator.url"
    ' 2>/dev/null \
  || kubectl -n "$NS" exec deploy/identity1230 -- printenv SPRING_APPLICATION_JSON 2>/dev/null \
  || echo "(SPRING_APPLICATION_JSON not set — run ./patch-service-urls.sh)"

echo
echo "=== 4) Actuator: effective REST URI (this is what identity actually calls) ==="
DEDICATED_HOST=${DEDICATED_HOST:-api-idrepo1230.qa11new.mosip.net}
API=${DEDICATED_HOST:-$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')}
curl -sk "https://${API}/idrepository/v1/identity/actuator/env" \
  | jq -r '
      .. | objects | to_entries[]?
      | select(.key == "mosip.idrepo.credential.request.rest.uri"
            or .key == "mosip.idrepo.credrequest.generator.url"
            or .key == "mosip.idrepo.credential.service.url")
      | "\(.key)=\(.value.value // .value)"
    ' 2>/dev/null || echo "(actuator/env not readable — check with kubectl logs)"

echo
echo "If rest.uri still contains credentialrequest.idrepo (no 1230), run:"
echo "  ./patch-service-urls.sh"
echo "Overrides of only mosip.idrepo.credrequest.generator.url are not enough:"
echo "RestRequestBuilder caches the expanded *.rest.uri from config-server."

echo
echo "=== 5) Quick DB checks (run in psql) ==="
cat <<'SQL'
-- Identity-side status (often in idrepo DB, not credential DB):
\c mosip_idrepo1230
SELECT count(*), max(cr_dtimes) FROM idrepo.credential_request_status;

-- Credential-side transactions (must move after identity → credrequest is fixed):
\c mosip_credential1230
SELECT count(*), max(cr_dtimes) FROM credential.credential_transaction;

-- Smoking gun: old DB advancing while new stuck means identity still calls old credrequest:
\c mosip_credential
SELECT count(*), max(cr_dtimes) FROM credential.credential_transaction;
SQL

echo
echo "=== 6) Fix if identity still points at credentialrequest.idrepo ==="
cat <<EOF
# Ensure overrides CM has:
#   SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_MOSIP_IDREPO_CREDREQUEST_GENERATOR_URL=$EXPECTED_CREDREQUEST_URL
#   SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_MOSIP_IDREPO_CREDENTIAL_SERVICE_URL=$EXPECTED_CREDENTIAL_URL
#   SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_MOSIP_IDREPO_IDENTITY_URL=$EXPECTED_IDENTITY_URL
#   SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_MOSIP_IDREPO_VID_URL=$EXPECTED_VID_URL
#
# Mount on identity1230 (zsh: quote --set):
helm -n $NS upgrade identity1230 mosip/identity --reuse-values \\
  --set 'extraEnvVarsCM[0]=global' \\
  --set 'extraEnvVarsCM[1]=config-server-share' \\
  --set 'extraEnvVarsCM[2]=artifactory-share' \\
  --set 'extraEnvVarsCM[3]=$OVERRIDES_CM'
kubectl -n $NS rollout restart deploy/identity1230
kubectl -n $NS rollout status deploy/identity1230
EOF
