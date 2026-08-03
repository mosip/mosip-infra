#!/bin/bash
# Unblock identity1230 credential notify on qa11new (cache name case mismatch).
#
# Why cmdline -D/--spring.cache.type=none is NOT enough on qa11new:
#   Actuator shows BOTH spring.cache.type=none AND =simple — config-server remote
#   properties still win for CacheManager construction. @Cacheable then fails with
#   Cannot find cache named 'Online_Verification_Partners'.
#
# Fix: drop idrepo1230-cache-force.jar onto loader.path. It registers an
# ApplicationContextInitializer (LOWEST_PRECEDENCE) that:
#   1) addFirst()s spring.cache.type=none + PascalCase names/maps (beats config-server)
#   2) replaces cacheManager with a dynamic ConcurrentMapCacheManager
#
# Keeps image ENTRYPOINT ./configure_start.sh (biosdk) — only overrides args/CMD.
#
# Usage:
#   ./apply-cache-cmdline.sh [kubeconfig]

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
NS=${NS:-idrepo1230}
DEPLOY=${DEPLOY:-identity1230}

DIR=$(cd "$(dirname "$0")" && pwd)
JAR="$DIR/lib/idrepo1230-cache-force.jar"
JAR_NAME="idrepo1230-cache-force.jar"

CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'
CACHE_SIZE_MAP="{ 'Online_Verification_Partners': 200, 'id_attributes': 200, 'uin_hash_salt': 100, 'uin_encrypt_salt': 100, 'DATASHARE_POLICIES': 200, 'PARTNER_EXTRACTOR_FORMATS': 200, 'topics': 200, 'credential_transaction': 200, 'online_verification_partners': 200, 'partner_extractor_formats': 200, 'datashare_policies': 200 }"
CACHE_EXPIRE_MAP="{ 'Online_Verification_Partners': 86400, 'id_attributes': 86400, 'uin_hash_salt': 86400, 'uin_encrypt_salt': 86400, 'DATASHARE_POLICIES': 86400, 'PARTNER_EXTRACTOR_FORMATS': 86400, 'topics': 86400, 'credential_transaction': 86400, 'online_verification_partners': 86400, 'partner_extractor_formats': 86400, 'datashare_policies': 86400 }"

set -euo pipefail

if [ ! -f "$JAR" ]; then
  echo "ERROR: missing $JAR" >&2
  exit 1
fi

JAR_B64=$(base64 -w0 "$JAR" 2>/dev/null || base64 "$JAR" | tr -d '\n')

# Build the in-container start script with python (quoted heredoc — no bash ${{}} expansion).
SCRIPT=$(
JAR_B64="$JAR_B64" \
JAR_NAME="$JAR_NAME" \
CACHE_NAMES="$CACHE_NAMES" \
CACHE_SIZE_MAP="$CACHE_SIZE_MAP" \
CACHE_EXPIRE_MAP="$CACHE_EXPIRE_MAP" \
python3 - <<'PY'
import os
jar_b64 = os.environ["JAR_B64"]
jar_name = os.environ["JAR_NAME"]
names = os.environ["CACHE_NAMES"]
size = os.environ["CACHE_SIZE_MAP"]
expire = os.environ["CACHE_EXPIRE_MAP"]

prop_body = f"""spring.cache.type=none
spring.cache.cache-names={names}
mosip.idrepo.cache.names={names}
mosip.idrepo.cache.size={size}
mosip.idrepo.cache.expire-in-seconds={expire}
"""

# Triple-quoted template: {{ → literal {{ for the pod shell; values filled by python.
print(f'''set -euo pipefail
cd /home/mosip
loader="${{loader_path_env:-/home/mosip/additional_jars/}}"
mod="${{current_module_env:-id-repository-identity-service}}"
mkdir -p "$loader" /home/mosip/config
[ -f "$loader/kernel-ref-idobjectvalidator.jar" ] || wget -q "${{artifactory_url_env}}/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/kernel-ref-idobjectvalidator.jar" -O "$loader/kernel-ref-idobjectvalidator.jar" || true
[ -f "$loader/kernel-auth-adapter.jar" ] || wget -q "${{iam_adapter_url_env}}" -O "$loader/kernel-auth-adapter.jar" || true

# Force-cache jar: ApplicationContextInitializer beats config-server after bootstrap.
echo '{jar_b64}' | base64 -d > "$loader/{jar_name}"
ls -la "$loader/{jar_name}"
echo "idrepo1230-cache-force.jar installed on loader.path"

cat > /home/mosip/config/cache-override.properties <<'PROP'
{prop_body}PROP

# context.initializer.classes forces the initializer even if loader.path
# spring.factories discovery is flaky; jar must still be on loader.path for the class.
exec java \\
  -Dloader.path="$loader" \\
  -Dcontext.initializer.classes=io.mosip.idrepo1230.CacheForceInitializer \\
  -Dspring.cloud.config.label="${{spring_config_label_env}}" \\
  -Dspring.profiles.active="${{active_profile_env}}" \\
  -Dspring.cloud.config.uri="${{spring_config_url_env}}" \\
  -Dspring.cloud.config.allow-override=true \\
  -Dspring.cloud.config.override-none=true \\
  -Dspring.cloud.config.override-system-properties=false \\
  -Dspring.cache.type=none \\
  -Dspring.cache.cache-names={names} \\
  -Dmosip.idrepo.cache.names={names} \\
  -Dspring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties \\
  -jar "${{mod}}.jar" \\
  --spring.cloud.config.allow-override=true \\
  --spring.cloud.config.override-none=true \\
  --spring.cloud.config.override-system-properties=false \\
  --spring.cache.type=none \\
  --spring.cache.cache-names={names} \\
  --mosip.idrepo.cache.names={names} \\
  --spring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties
''')
PY
)

echo "$SCRIPT" | grep -q 'idrepo1230-cache-force.jar'
echo "$SCRIPT" | grep -q 'context.initializer.classes=io.mosip.idrepo1230.CacheForceInitializer'
echo "$SCRIPT" | grep -q '\-Dspring.cache.type=none'

echo "==> Patch deploy $DEPLOY (cache-force jar on loader.path; ENTRYPOINT kept)"
CUR=$(kubectl -n "$NS" get deploy "$DEPLOY" -o json)
PATCH=$(CUR="$CUR" SCRIPT="$SCRIPT" python3 - <<'PY'
import json, os
dep = json.loads(os.environ["CUR"])
script = os.environ["SCRIPT"]
c0 = dep["spec"]["template"]["spec"]["containers"][0]
ops = []
if c0.get("command") is not None:
    ops.append({"op": "remove", "path": "/spec/template/spec/containers/0/command"})
ops.append({
  "op": "replace" if c0.get("args") else "add",
  "path": "/spec/template/spec/containers/0/args",
  "value": ["/bin/bash", "-lc", script],
})
print(json.dumps(ops))
PY
)
kubectl -n "$NS" patch deployment "$DEPLOY" --type=json -p="$PATCH"

kubectl -n "$NS" set env deployment/"$DEPLOY" JAVA_TOOL_OPTIONS- 2>/dev/null || true
kubectl -n "$NS" set env deployment/"$DEPLOY" \
  SPRING_CLOUD_CONFIG_ALLOW_OVERRIDE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_NONE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false \
  SPRING_CACHE_TYPE=none \
  "SPRING_CACHE_CACHE_NAMES=$CACHE_NAMES" \
  "MOSIP_IDREPO_CACHE_NAMES=$CACHE_NAMES"

kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=300s

echo "==> Verify java cmdline + force jar"
sleep 20
JAVA_LINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'ps -o args -A | grep "[j]ava.*id-repository-identity" | head -1' || true)
echo "$JAVA_LINE"
if ! echo "$JAVA_LINE" | grep -qE '\-Dspring.cache.type=none|--spring.cache.type=none'; then
  echo "ERROR: java cmdline missing spring.cache.type=none"
  exit 1
fi
kubectl -n "$NS" exec deploy/"$DEPLOY" -- ls -la /home/mosip/additional_jars/idrepo1230-cache-force.jar
echo "OK: force jar present on loader.path"

echo "==> Startup marker (initializer / cache manager)"
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=5m 2>/dev/null \
  | grep -E 'idrepo1230CacheForce|CacheForceInitializer|DynamicCacheManager|Cannot find cache named' \
  | tail -20 || true

echo "==> Error count since new pod (expect 0)"
# Prefer errors only from the current pod to avoid stale --since noise
POD=$(kubectl -n "$NS" get pod -l app=identity1230 -o jsonpath='{.items[0].metadata.name}' 2>/dev/null \
  || kubectl -n "$NS" get pod -o name 2>/dev/null | grep identity1230 | head -1 | sed 's|pod/||')
sleep 40
if [ -n "${POD:-}" ]; then
  ERR=$(kubectl -n "$NS" logs "$POD" --since=2m 2>/dev/null \
    | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
  echo "pod=$POD error count: $ERR"
else
  ERR=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
    | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
  echo "error count: $ERR"
fi
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -E 'PARTNERS_IDENTIFIED|Caching Online_Verification|BIO_SDK|Application run failed' | tail -15 || true
[ "${ERR:-0}" = "0" ]
