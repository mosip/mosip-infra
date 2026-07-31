#!/bin/bash
# Fix: Cannot find cache named 'Online_Verification_Partners'
#
# qa11new id-repository-dev.properties locks simple-cache names to
#   online_verification_partners (lowercase)
# while Java @Cacheable looks up Online_Verification_Partners.
#
# Config-server beats env / JAVA_TOOL_OPTIONS / SPRING_APPLICATION_JSON.
# This script replaces the container command+args so Spring Boot gets
# --spring.cache.cache-names=... as application args after the jar.
#
# Usage: ./fix-cache.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=${NS:-idrepo1230}
DEPLOY=${DEPLOY:-identity1230}
CACHE_CM=${CACHE_CM:-idrepo1230-cache}
REST_CM=${REST_CM:-idrepo1230-rest-uris}
CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'

set -euo pipefail

echo "==> 0) Current command/args (must change after patch)"
kubectl -n "$NS" get deploy "$DEPLOY" -o jsonpath='command={.spec.template.spec.containers[0].command}{"\n"}args={.spec.template.spec.containers[0].args}{"\n"}'
echo "--- pid1 ---"
kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'tr "\0" " " </proc/1/cmdline; echo' 2>/dev/null | head -c 500 || true
echo

echo "==> 1) Supporting ConfigMaps"
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

echo "==> 2) Replace container command+args (ignore image ENTRYPOINT/CMD)"
# Replacing both command and args ensures image CMD cannot win.
# configure_start.sh (biosdk) is skipped; identity typically does not need it for this job.
START_SCRIPT=$(CACHE_NAMES="$CACHE_NAMES" python3 - <<'PY'
import os
names = os.environ["CACHE_NAMES"]
print(f'''set -euo pipefail
cd /home/mosip
loader="${{loader_path_env:-/home/mosip/additional_jars/}}"
mod="${{current_module_env:-id-repository-identity-service}}"
mkdir -p "$loader"
if [ ! -f "$loader/kernel-ref-idobjectvalidator.jar" ]; then
  wget -q "${{artifactory_url_env}}/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/kernel-ref-idobjectvalidator.jar" -O "$loader/kernel-ref-idobjectvalidator.jar" || true
fi
if [ ! -f "$loader/kernel-auth-adapter.jar" ]; then
  wget -q "${{iam_adapter_url_env}}" -O "$loader/kernel-auth-adapter.jar" || true
fi
# -D* before -jar (JVM); --spring.* after jar (app args, beat config-server)
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

PATCH=$(START_SCRIPT="$START_SCRIPT" python3 - <<'PY'
import json, os
script = os.environ["START_SCRIPT"]
# Use replace when present, add when absent — emit a robust patch list
ops = []
# Always set command
ops.append({"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/bin/bash", "-lc"]})
ops.append({"op": "add", "path": "/spec/template/spec/containers/0/args", "value": [script]})
print(json.dumps(ops))
PY
)

# Detect existing command/args to choose add vs replace
HAS_CMD=$(kubectl -n "$NS" get deploy "$DEPLOY" -o jsonpath='{.spec.template.spec.containers[0].command}' || true)
HAS_ARGS=$(kubectl -n "$NS" get deploy "$DEPLOY" -o jsonpath='{.spec.template.spec.containers[0].args}' || true)
PATCH=$(START_SCRIPT="$START_SCRIPT" HAS_CMD="$HAS_CMD" HAS_ARGS="$HAS_ARGS" python3 - <<'PY'
import json, os
script = os.environ["START_SCRIPT"]
has_cmd = bool(os.environ.get("HAS_CMD", "").strip())
has_args = bool(os.environ.get("HAS_ARGS", "").strip())
ops = []
ops.append({
  "op": "replace" if has_cmd else "add",
  "path": "/spec/template/spec/containers/0/command",
  "value": ["/bin/bash", "-lc"],
})
ops.append({
  "op": "replace" if has_args else "add",
  "path": "/spec/template/spec/containers/0/args",
  "value": [script],
})
print(json.dumps(ops))
PY
)

echo "Applying patch..."
kubectl -n "$NS" patch deployment "$DEPLOY" --type=json -p="$PATCH"

kubectl -n "$NS" set env deployment/"$DEPLOY" JAVA_TOOL_OPTIONS- 2>/dev/null || true
kubectl -n "$NS" set env deployment/"$DEPLOY" \
  SPRING_CACHE_TYPE=simple \
  SPRING_CACHE_CACHE_NAMES="$CACHE_NAMES" \
  SPRING_CLOUD_CONFIG_ALLOW_OVERRIDE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_NONE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false

echo "==> 3) Wait for rollout"
kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=300s

echo "==> 4) Verify deployment spec + pid1"
kubectl -n "$NS" get deploy "$DEPLOY" -o jsonpath='command={.spec.template.spec.containers[0].command}{"\n"}'
kubectl -n "$NS" get deploy "$DEPLOY" -o json | python3 -c '
import json,sys
d=json.load(sys.stdin)
args=d["spec"]["template"]["spec"]["containers"][0].get("args") or []
text=" ".join(args)
print("args_contain_Online_Verification_Partners=", "Online_Verification_Partners" in text)
'
# pid1 may briefly be bash; find java cmdline
sleep 5
echo "--- process list ---"
kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'ps -o pid,args -A | grep -E "[j]ava|[b]ash" | head -10' || true
JAVA_LINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'ps -o args -A | grep "[j]ava.*id-repository-identity-service" | head -1' || true)
echo "JAVA: $JAVA_LINE"
if ! echo "$JAVA_LINE" | grep -q 'Online_Verification_Partners'; then
  echo "ERROR: java process still missing --spring.cache.cache-names=Online_Verification_Partners"
  echo "Deployment args may have been overwritten by helm; re-check:"
  echo "  kubectl -n $NS get deploy $DEPLOY -o yaml | sed -n '/containers:/,/volumes:/p' | head -80"
  exit 1
fi
echo "OK: java has Online_Verification_Partners"

echo "==> 5) Log check (expect 0)"
sleep 45
ERR_COUNT=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
echo "error count: ${ERR_COUNT:-0}"
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -E 'PARTNERS_IDENTIFIED|requestgenerator|Cannot find cache named' \
  | tail -15 || true

if [ "${ERR_COUNT:-0}" != "0" ]; then
  echo "STILL FAILING despite cmdline override — check actuator/env for effective cache-names."
  echo "Permanent fix: mosip-config qa11new id-repository-dev.properties mosip.idrepo.cache.names=$CACHE_NAMES"
  exit 1
fi
echo "Done. Re-check mosip_credential1230.credential_transaction growth."
