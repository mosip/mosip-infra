#!/bin/bash
# Why is mosip_credential1230 stuck at 1 row?
# Identity AddIdentity can pass while the background credential job still fails
# (cache) or still calls credentialrequest.idrepo (old DB).
#
# Usage: ./diagnose-credential-path.sh [kubeconfig]

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
NS=${NS:-idrepo1230}
DEPLOY=${DEPLOY:-identity1230}
DEDICATED_HOST=${DEDICATED_HOST:-api-idrepo1230.qa11new.mosip.net}

set -euo pipefail

pass=0
fail=0
check() {
  local name="$1" ok="$2" detail="${3:-}"
  if [ "$ok" = "1" ]; then
    echo "OK   $name ${detail}"
    pass=$((pass+1))
  else
    echo "FAIL $name ${detail}"
    fail=$((fail+1))
  fi
}

echo "=== A) identity1230 java cache override ==="
JAVA_LINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc \
  'ps -o args -A | grep "[j]ava.*id-repository-identity" | head -1' 2>/dev/null || true)
if echo "$JAVA_LINE" | grep -q '\-Dmosip.idrepo.cache.names=Online_Verification_Partners'; then
  check "java has -Dmosip.idrepo.cache.names=Online_Verification_Partners" 1
else
  check "java has -Dmosip.idrepo.cache.names=Online_Verification_Partners" 0 \
    "(run ./apply-cache-cmdline.sh — helm upgrade often wipes args)"
  echo "    java: ${JAVA_LINE:0:220}..."
fi

ERR=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=10m 2>/dev/null \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
if [ "${ERR:-0}" = "0" ]; then
  check "cache error count last 10m == 0" 1 "(count=$ERR)"
else
  check "cache error count last 10m == 0" 0 "(count=$ERR — credential notify never runs)"
fi

PARTNERS=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=10m 2>/dev/null \
  | grep -c 'PARTNERS_IDENTIFIED' || true)
echo "INFO PARTNERS_IDENTIFIED log hits (10m): $PARTNERS"

echo
echo "=== B) identity → credentialrequest REST URI ==="
ENV_JSON=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- printenv SPRING_APPLICATION_JSON 2>/dev/null || true)
if echo "$ENV_JSON" | grep -q 'credentialrequest1230'; then
  check "SPRING_APPLICATION_JSON contains credentialrequest1230" 1
else
  check "SPRING_APPLICATION_JSON contains credentialrequest1230" 0 \
    "(run ./patch-service-urls.sh — must APPLY, not only create CM)"
  echo "    SPRING_APPLICATION_JSON=${ENV_JSON:0:180}"
fi

# Prefer dedicated host if set; fall back to api-internal
for BASE in "https://${DEDICATED_HOST}" \
            "https://$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')"; do
  echo "Trying actuator at $BASE ..."
  ACT=$(curl -sk --max-time 15 "$BASE/idrepository/v1/identity/actuator/env" 2>/dev/null || true)
  if [ -n "$ACT" ] && echo "$ACT" | grep -q 'credential.request.rest.uri\|credrequest.generator'; then
    echo "$ACT" | jq -r '
      .. | objects | to_entries[]?
      | select(.key == "mosip.idrepo.credential.request.rest.uri"
            or .key == "mosip.idrepo.credrequest.generator.url")
      | "\(.key)=\(.value.value // .value)"
    ' 2>/dev/null || true
    URI=$(echo "$ACT" | jq -r '
      .. | objects | to_entries[]?
      | select(.key == "mosip.idrepo.credential.request.rest.uri")
      | (.value.value // .value)
    ' 2>/dev/null | head -1)
    if echo "$URI" | grep -q 'credentialrequest1230'; then
      check "actuator rest.uri → credentialrequest1230" 1 "($URI)"
    else
      check "actuator rest.uri → credentialrequest1230" 0 "($URI)"
    fi
    break
  fi
done

echo
echo "=== C) identity logs: which host is called? ==="
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=30m 2>/dev/null \
  | grep -E 'credentialrequest|requestgenerator|Online_Verification|PARTNERS_IDENTIFIED|notifyUinCredential' \
  | tail -40 || echo "(no matching log lines)"

echo
echo "=== D) SQL — run these (smoking gun) ==="
cat <<'SQL'
-- Parallel stack (must MOVE after a new AddIdentity):
\c mosip_credential1230
SELECT count(*) AS rows, max(cr_dtimes) AS last_tx FROM credential.credential_transaction;

-- Identity-side queue (idrepo DB):
\c mosip_idrepo1230
SELECT status, count(*), max(cr_dtimes)
FROM idrepo.credential_request_status
GROUP BY status
ORDER BY 1;

-- If THIS advances while credential1230 stays on 2026-07-29, identity still hits OLD credrequest:
\c mosip_credential
SELECT count(*) AS rows, max(cr_dtimes) AS last_tx FROM credential.credential_transaction;
SQL

echo
echo "=== E) Summary: $pass OK / $fail FAIL ==="
if [ "$fail" -gt 0 ]; then
  echo "Fix order:"
  echo "  1) ./apply-cache-cmdline.sh          # until cache error count is 0"
  echo "  2) ./patch-service-urls.sh           # applies SPRING_APPLICATION_JSON to deploys"
  echo "  3) create ONE identity via dedicated host, re-check mosip_credential1230 max(cr_dtimes)"
  exit 1
fi
echo "Wiring looks OK — if DB still stuck, check credentialrequest1230 datasource DB name."
exit 0
