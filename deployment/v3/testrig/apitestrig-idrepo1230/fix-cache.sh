#!/bin/bash
# Fix: Cannot find cache named 'Online_Verification_Partners'
#
# Root cause (qa11new id-repository-*-properties):
#   mosip.idrepo.cache.names=...,online_verification_partners,...
#   spring.cache.type=simple
#   spring.cache.cache-names=${mosip.idrepo.cache.names}
#
# Java @Cacheable uses different case:
#   Online_Verification_Partners, DATASHARE_POLICIES, PARTNER_EXTRACTOR_FORMATS
#
# ConcurrentMapCacheManager locks names when cache-names is set, so the
# Pascal/UPPER lookup fails. Redis allows runtime cache creation (why default
# profile worked); simple does not.
#
# Env SPRING_CACHE_* often loses to config-server (overrideSystemProperties).
# This script forces correct names via SPRING_APPLICATION_JSON + JAVA_TOOL_OPTIONS.
#
# Usage: ./fix-cache.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=${NS:-idrepo1230}
CACHE_CM=${CACHE_CM:-idrepo1230-cache}
REST_CM=${REST_CM:-idrepo1230-rest-uris}
DEPLOY=${DEPLOY:-identity1230}

# Exact @Cacheable cacheNames from id-repository 1.2.3.0 sources
CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'

set -euo pipefail

echo "==> 1) ConfigMap $CACHE_CM (env hint; may lose to config-server alone)"
kubectl -n "$NS" create configmap "$CACHE_CM" \
  --from-literal=SPRING_CACHE_TYPE=simple \
  --from-literal=SPRING_CACHE_CACHE_NAMES="$CACHE_NAMES" \
  --from-literal=SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false \
  --from-literal=JAVA_TOOL_OPTIONS="-Dspring.cache.type=simple -Dspring.cache.cache-names=${CACHE_NAMES} -Dmosip.idrepo.cache.names=${CACHE_NAMES}" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "==> 2) Merge cache fix into $REST_CM SPRING_APPLICATION_JSON (if present)"
if kubectl -n "$NS" get cm "$REST_CM" >/dev/null 2>&1; then
  EXISTING=$(kubectl -n "$NS" get cm "$REST_CM" -o jsonpath='{.data.SPRING_APPLICATION_JSON}')
  MERGED=$(EXISTING="$EXISTING" CACHE_NAMES="$CACHE_NAMES" python3 - <<'PY'
import json, os
data = json.loads(os.environ["EXISTING"] or "{}")
names = os.environ["CACHE_NAMES"]
data["spring.cache.type"] = "simple"
data["spring.cache.cache-names"] = names
data["mosip.idrepo.cache.names"] = names
print(json.dumps(data, separators=(",", ":")))
PY
)
  kubectl -n "$NS" create configmap "$REST_CM" \
    --from-literal=SPRING_APPLICATION_JSON="$MERGED" \
    --dry-run=client -o yaml | kubectl apply -f -
  echo "    merged SPRING_APPLICATION_JSON cache keys"
else
  echo "    (no $REST_CM — run ./patch-service-urls.sh first, or rely on JAVA_TOOL_OPTIONS)"
fi

echo "==> 3) Inject env into $DEPLOY from $CACHE_CM and restart"
kubectl -n "$NS" set env deployment/"$DEPLOY" --from=configmap/"$CACHE_CM" --overwrite
kubectl -n "$NS" rollout restart deployment/"$DEPLOY"
kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=180s

echo
echo "==> 4) Verify pod env (must show Online_Verification_Partners, not lowercase)"
kubectl -n "$NS" exec deploy/"$DEPLOY" -- printenv JAVA_TOOL_OPTIONS SPRING_CACHE_CACHE_NAMES SPRING_CACHE_TYPE 2>/dev/null || true

echo
echo "==> 5) Wait for credential job cycles, then check logs"
sleep 45

ERR_COUNT=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
echo "--- error count (expect 0): ${ERR_COUNT:-0} ---"

echo "--- partners / requestgenerator ---"
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -E 'PARTNERS_IDENTIFIED|requestgenerator|Cannot find cache named' \
  | tail -20 || true

echo "--- in-cluster actuator (localhost; ignore if unauthorized) ---"
# Hit the pod directly — gateway actuator/env often needs auth / returns empty HTML.
kubectl -n "$NS" exec deploy/"$DEPLOY" -- \
  wget -qO- --timeout=5 http://127.0.0.1:8090/idrepository/v1/identity/actuator/env 2>/dev/null \
  | python3 -c '
import json,sys
raw=sys.stdin.read().strip()
if not raw:
  print("(empty actuator response)"); sys.exit(0)
try:
  env=json.loads(raw)
except Exception as e:
  print("actuator parse failed:", e, "head:", raw[:120]); sys.exit(0)
want={"spring.cache.type","spring.cache.cache-names","mosip.idrepo.cache.names"}
for ps in env.get("propertySources",[]):
  props=ps.get("properties") or {}
  hit={k:props[k] for k in want if k in props}
  if hit:
    print(ps.get("name"), "=>")
    for k,v in hit.items():
      val=v.get("value") if isinstance(v,dict) else v
      print(f"  {k}={val}")
' || echo "(actuator check skipped)"

echo
if [ "${ERR_COUNT:-0}" != "0" ]; then
  echo "STILL FAILING: config-server may still win. Confirm JAVA_TOOL_OPTIONS in printenv above"
  echo "contains Online_Verification_Partners. Permanent fix: mosip-config qa11new"
  echo "id-repository-dev.properties mosip.idrepo.cache.names → Java @Cacheable names."
  exit 1
fi
echo "Cache name error cleared. Re-check mosip_credential1230.credential_transaction growth."