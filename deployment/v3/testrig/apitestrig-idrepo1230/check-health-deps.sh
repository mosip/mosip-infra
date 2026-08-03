#!/bin/bash
# Curl every actuator that idrepo apitestrig (v1.2.3.0 healthCheckEndpoint.properties)
# treats as an idrepo dependency. A non-200/DOWN response makes related cases SKIP.
#
# Usage:
#   ./check-health-deps.sh
#   DEDICATED_HOST=api-idrepo1230.qa11new.mosip.net ./check-health-deps.sh
#
# After failures: ./create-dedicated-host-vs.sh  (refresh proxies), then re-check.
# DB/JDBC skips are separate — see README (DB_HOST/DB_PORT).

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi

DEDICATED_HOST=${DEDICATED_HOST:-}
if [ -z "$DEDICATED_HOST" ]; then
  API=$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}' 2>/dev/null || true)
  if [ -n "$API" ]; then
    DEDICATED_HOST=$(echo "$API" | sed 's/^api-internal\./api-idrepo1230./')
  fi
fi
if [ -z "$DEDICATED_HOST" ]; then
  echo "Set DEDICATED_HOST=api-idrepo1230.<env>.mosip.net"
  exit 1
fi

BASE="https://${DEDICATED_HOST}"

# Exact paths whose module tag includes "idrepo" in apitest-idrepo 1.2.3.0
# healthCheckEndpoint.properties (any DOWN → HealthChecker can skip remaining cases).
PATHS=(
  "idrepo|/idrepository/v1/identity/actuator/health"
  "idrepo|/idrepository/v1/actuator/health"
  "idrepo|/v1/authmanager/actuator/health"
  "idrepo|/v1/keymanager/actuator/health"
  "idrepo|/v1/masterdata/actuator/health"
  "idrepo|/v1/auditmanager/actuator/health"
  "idrepo|/v1/notifier/actuator/health"
  "idrepo|/v1/datashare/actuator/health"
  "idrepo|/biosdk-service/actuator/health"
  "idrepo|/hub/actuator/health"
  "idrepo|/v1/idgenerator/actuator/health"
  "idrepo|/v1/partnermanager/actuator/health"
  # Parallel stack (not idrepo-tagged upstream, but needed for credential cases)
  "parallel|/v1/credentialservice/actuator/health"
  "parallel|/v1/credentialrequest/actuator/health"
)

pass=0
fail=0

echo "Checking health deps on $BASE"
echo

for entry in "${PATHS[@]}"; do
  tag=${entry%%|*}
  path=${entry#*|}
  url="${BASE}${path}"
  code=$(curl -sk -o /tmp/idrepo1230-health.json -w '%{http_code}' --max-time 15 "$url" || echo "000")
  status=$(python3 - <<'PY' 2>/dev/null || true
import json
try:
  d=json.load(open("/tmp/idrepo1230-health.json"))
  print(d.get("status") or d.get("statusCode") or "")
except Exception:
  print("")
PY
)
  if [ "$code" = "200" ] && { [ -z "$status" ] || [ "$status" = "UP" ]; }; then
    echo "OK   [$tag] $path  (HTTP $code ${status})"
    pass=$((pass+1))
  else
    echo "FAIL [$tag] $path  (HTTP $code ${status:-no-body})"
    fail=$((fail+1))
  fi
done

echo
echo "Summary: $pass OK / $fail FAIL"
echo
echo "Skip drivers (beyond health):"
echo "  • eSignet=no at install time → esignet-tagged cases skipped (expected)"
echo "  • Upstream testCaseSkippedList.txt (~20 known-issue cases always skip)"
echo "  • DOB/Email/handle schema mismatches → FEATURE_NOT_SUPPORTED skips"
echo "  • JDBC cleanup fails if db-server is api-internal:5432 — reinstall with:"
echo "      DB_HOST=172.31.15.40 DB_PORT=5433 ENV_ENDPOINT=https://$DEDICATED_HOST ./install.sh"
echo "  • After a run: ./diagnose-skips.sh  (histogram of SkipException reasons from pod logs)"
echo
if [ "$fail" -gt 0 ]; then
  echo "Refresh dedicated VS proxies, then re-run this script:"
  echo "  ./create-dedicated-host-vs.sh"
  echo "  ./check-health-deps.sh"
  exit 1
fi
exit 0
