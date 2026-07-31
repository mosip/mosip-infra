#!/bin/bash
# Fix: Cannot find cache named 'Online_Verification_Partners'
#
# Root cause (qa11new id-repository-dev.properties):
#   mosip.idrepo.cache.names=...,online_verification_partners,...  # lowercase
#   spring.cache.type=simple
#   spring.cache.cache-names=${mosip.idrepo.cache.names}
#
# Java @Cacheable uses Online_Verification_Partners (case-sensitive).
# ConcurrentMapCacheManager locks names → lookup fails.
#
# Env / JAVA_TOOL_OPTIONS lose to config-server. This script replaces the
# container CMD with a wrapper that passes Spring Boot *application* args
# after the jar (highest precedence).
#
# Usage: ./fix-cache.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=${NS:-idrepo1230}
CACHE_CM=${CACHE_CM:-idrepo1230-cache}
REST_CM=${REST_CM:-idrepo1230-rest-uris}
DEPLOY=${DEPLOY:-identity1230}
CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'

set -euo pipefail

echo "==> 0) Diagnose"
kubectl -n "$NS" exec deploy/"$DEPLOY" -- printenv \
  JAVA_TOOL_OPTIONS SPRING_CACHE_CACHE_NAMES SPRING_APPLICATION_JSON \
  SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES SPRING_CLOUD_CONFIG_OVERRIDE_NONE \
  2>/dev/null || true
echo "--- pid1 cmdline ---"
kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'tr "\0" " " </proc/1/cmdline; echo' 2>/dev/null | head -c 1500 || true
echo

echo "==> 1) ConfigMap $CACHE_CM + rest-uris JSON merge"
kubectl -n "$NS" create configmap "$CACHE_CM" \
  --from-literal=SPRING_CACHE_TYPE=simple \
  --from-literal=SPRING_CACHE_CACHE_NAMES="$CACHE_NAMES" \
  --from-literal=SPRING_CLOUD_CONFIG_ALLOW_OVERRIDE=true \
  --from-literal=SPRING_CLOUD_CONFIG_OVERRIDE_NONE=true \
  --from-literal=SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false \
  --dry-run=client -o yaml | kubectl apply -f -

if kubectl -n "$NS" get cm "$REST_CM" >/dev/null 2>&1; then
  EXISTING=$(kubectl -n "$NS" get cm "$REST_CM" -o jsonpath='{.data.SPRING_APPLICATION_JSON}')
  MERGED=$(EXISTING="$EXISTING" CACHE_NAMES="$CACHE_NAMES" python3 - <<'PY'
import json, os
data = json.loads(os.environ["EXISTING"] or "{}")
names = os.environ["CACHE_NAMES"]
data.update({
  "spring.cache.type": "simple",
  "spring.cache.cache-names": names,
  "mosip.idrepo.cache.names": names,
  "spring.cloud.config.allow-override": True,
  "spring.cloud.config.override-none": True,
  "spring.cloud.config.override-system-properties": False,
})
print(json.dumps(data, separators=(",", ":")))
PY
)
  kubectl -n "$NS" create configmap "$REST_CM" \
    --from-literal=SPRING_APPLICATION_JSON="$MERGED" \
    --dry-run=client -o yaml | kubectl apply -f -
fi

echo "==> 2) Patch $DEPLOY container args (Spring Boot args after jar)"
# Build bash -lc script used as container args (replaces image CMD; entrypoint kept)
START_SCRIPT=$(CACHE_NAMES="$CACHE_NAMES" python3 - <<'PY'
import os
names = os.environ["CACHE_NAMES"]
print(f'''set -euo pipefail
loader="${{loader_path_env:-/home/mosip/additional_jars/}}"
mod="${{current_module_env:-id-repository-identity-service}}"
mkdir -p "$loader"
[ -f "$loader/kernel-ref-idobjectvalidator.jar" ] || wget -q "${{artifactory_url_env}}/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/kernel-ref-idobjectvalidator.jar" -O "$loader/kernel-ref-idobjectvalidator.jar" || true
[ -f "$loader/kernel-auth-adapter.jar" ] || wget -q "${{iam_adapter_url_env}}" -O "$loader/kernel-auth-adapter.jar" || true
exec java \\
  -Dloader.path="$loader" \\
  -Dspring.cloud.config.label="${{spring_config_label_env}}" \\
  -Dspring.profiles.active="${{active_profile_env}}" \\
  -Dspring.cloud.config.uri="${{spring_config_url_env}}" \\
  -jar "${{mod}}.jar" \\
  --spring.cloud.config.allow-override=true \\
  --spring.cloud.config.override-none=true \\
  --spring.cloud.config.override-system-properties=false \\
  --spring.cache.type=simple \\
  --spring.cache.cache-names={names} \\
  --mosip.idrepo.cache.names={names}
''')
PY
)

# JSON-patch args onto first container
PATCH=$(START_SCRIPT="$START_SCRIPT" python3 - <<'PY'
import json, os
script = os.environ["START_SCRIPT"]
patch = [
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/args",
    "value": ["/bin/bash", "-lc", script],
  }
]
# If args already exist, replace instead of add
print(json.dumps(patch))
PY
)

# Try replace first (args already present from a prior run), else add
if kubectl -n "$NS" get deploy "$DEPLOY" -o jsonpath='{.spec.template.spec.containers[0].args}' | grep -q .; then
  PATCH=$(START_SCRIPT="$START_SCRIPT" python3 -c 'import json,os; print(json.dumps([{"op":"replace","path":"/spec/template/spec/containers/0/args","value":["/bin/bash","-lc",os.environ["START_SCRIPT"]]}]))')
fi

kubectl -n "$NS" patch deployment "$DEPLOY" --type=json -p="$PATCH"

echo "==> 3) Inject override-none env; drop stale JAVA_TOOL_OPTIONS"
kubectl -n "$NS" set env deployment/"$DEPLOY" JAVA_TOOL_OPTIONS- || true
kubectl -n "$NS" set env deployment/"$DEPLOY" \
  SPRING_CACHE_TYPE=simple \
  SPRING_CACHE_CACHE_NAMES="$CACHE_NAMES" \
  SPRING_CLOUD_CONFIG_ALLOW_OVERRIDE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_NONE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false

kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=240s

echo
echo "==> 4) Confirm application args on pid1"
CMDLINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'tr "\0" " " </proc/1/cmdline; echo' 2>/dev/null || true)
echo "$CMDLINE" | head -c 2000; echo
if echo "$CMDLINE" | grep -q 'Online_Verification_Partners'; then
  echo "OK: Online_Verification_Partners present on java cmdline"
else
  echo "ERROR: cmdline missing Online_Verification_Partners — aborting before wait"
  exit 1
fi

echo
echo "==> 5) Wait for credential job; expect error count 0"
sleep 50
ERR_COUNT=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
echo "error count: ${ERR_COUNT:-0}"
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -E 'PARTNERS_IDENTIFIED|requestgenerator|Cannot find cache named' \
  | tail -15 || true

if [ "${ERR_COUNT:-0}" != "0" ]; then
  echo
  echo "STILL FAILING after cmdline override."
  echo "Permanent fix in mosip-config qa11new id-repository-dev.properties:"
  echo "  mosip.idrepo.cache.names=$CACHE_NAMES"
  exit 1
fi
echo "Cache errors cleared. Re-check mosip_credential1230.credential_transaction."
