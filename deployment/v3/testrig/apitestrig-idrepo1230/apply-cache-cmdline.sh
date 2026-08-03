#!/bin/bash
# Fix Online_Verification_Partners via MOSIP SimpleCacheConfig.
#
# id-repository (1.2.3.x) SimpleCacheConfig builds caches ONLY from:
#   mosip.idrepo.cache.names
# Names must match @Cacheable exactly AND exist as keys in
# mosip.idrepo.cache.size / expire-in-seconds maps.
#
# Keeps image ENTRYPOINT ./configure_start.sh (biosdk) — only overrides args/CMD.
#
# Usage: ./apply-cache-cmdline.sh [kubeconfig]

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
NS=${NS:-idrepo1230}
DEPLOY=${DEPLOY:-identity1230}

CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'
CACHE_SIZE_MAP="{ 'Online_Verification_Partners': 200, 'id_attributes': 200, 'uin_hash_salt': 100, 'uin_encrypt_salt': 100, 'DATASHARE_POLICIES': 200, 'PARTNER_EXTRACTOR_FORMATS': 200, 'topics': 200, 'credential_transaction': 200, 'online_verification_partners': 200, 'partner_extractor_formats': 200, 'datashare_policies': 200 }"
CACHE_EXPIRE_MAP="{ 'Online_Verification_Partners': 86400, 'id_attributes': 86400, 'uin_hash_salt': 86400, 'uin_encrypt_salt': 86400, 'DATASHARE_POLICIES': 86400, 'PARTNER_EXTRACTOR_FORMATS': 86400, 'topics': 86400, 'credential_transaction': 86400, 'online_verification_partners': 86400, 'partner_extractor_formats': 86400, 'datashare_policies': 86400 }"

set -euo pipefail

# Build the in-container start script with python (quoted heredoc — no bash ${{}} expansion).
SCRIPT=$(
CACHE_NAMES="$CACHE_NAMES" \
CACHE_SIZE_MAP="$CACHE_SIZE_MAP" \
CACHE_EXPIRE_MAP="$CACHE_EXPIRE_MAP" \
python3 - <<'PY'
import os
names = os.environ["CACHE_NAMES"]
size = os.environ["CACHE_SIZE_MAP"]
expire = os.environ["CACHE_EXPIRE_MAP"]
# Triple-quoted template: {{ → literal { for the pod shell; {names} filled by python.
print(f'''set -euo pipefail
cd /home/mosip
loader="${{loader_path_env:-/home/mosip/additional_jars/}}"
mod="${{current_module_env:-id-repository-identity-service}}"
mkdir -p "$loader" /home/mosip/config
[ -f "$loader/kernel-ref-idobjectvalidator.jar" ] || wget -q "${{artifactory_url_env}}/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/kernel-ref-idobjectvalidator.jar" -O "$loader/kernel-ref-idobjectvalidator.jar" || true
[ -f "$loader/kernel-auth-adapter.jar" ] || wget -q "${{iam_adapter_url_env}}" -O "$loader/kernel-auth-adapter.jar" || true

cat > /home/mosip/config/cache-override.properties <<'PROP'
spring.cache.type=simple
mosip.idrepo.cache.names={names}
mosip.idrepo.cache.size={size}
mosip.idrepo.cache.expire-in-seconds={expire}
PROP

# -D* BEFORE -jar so they are JVM system properties (beat config-server when
# override-system-properties=false). SimpleCacheConfig reads mosip.idrepo.cache.names.
exec java \\
  -Dloader.path="$loader" \\
  -Dspring.cloud.config.label="${{spring_config_label_env}}" \\
  -Dspring.profiles.active="${{active_profile_env}}" \\
  -Dspring.cloud.config.uri="${{spring_config_url_env}}" \\
  -Dspring.cloud.config.allow-override=true \\
  -Dspring.cloud.config.override-none=true \\
  -Dspring.cloud.config.override-system-properties=false \\
  -Dspring.cache.type=simple \\
  -Dmosip.idrepo.cache.names={names} \\
  -Dspring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties \\
  -jar "${{mod}}.jar" \\
  --spring.cloud.config.allow-override=true \\
  --spring.cloud.config.override-none=true \\
  --spring.cloud.config.override-system-properties=false \\
  --spring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties \\
  --spring.cache.type=simple \\
  --mosip.idrepo.cache.names={names}
''')
PY
)

# Sanity: generated script must contain the cache system property for the pod shell
echo "$SCRIPT" | grep -q '\-Dmosip.idrepo.cache.names=Online_Verification_Partners'

echo "==> Patch deploy $DEPLOY (ENTRYPOINT kept; args = CMD wrapper)"
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
  SPRING_CACHE_TYPE=simple \
  "MOSIP_IDREPO_CACHE_NAMES=$CACHE_NAMES"

kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=300s

echo "==> Verify -Dmosip.idrepo.cache.names on java"
sleep 15
JAVA_LINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'ps -o args -A | grep "[j]ava.*id-repository-identity" | head -1' || true)
echo "$JAVA_LINE"
if ! echo "$JAVA_LINE" | grep -q '\-Dmosip.idrepo.cache.names=Online_Verification_Partners'; then
  echo "ERROR: java cmdline missing -Dmosip.idrepo.cache.names"
  exit 1
fi
echo "OK: system property set"

echo "==> Confirm properties file inside pod"
kubectl -n "$NS" exec deploy/"$DEPLOY" -- cat /home/mosip/config/cache-override.properties || true

echo "==> Error count (expect 0)"
sleep 50
ERR=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
echo "error count: $ERR"
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -E 'PARTNERS_IDENTIFIED|Caching Online_Verification|BIO_SDK|Application run failed' | tail -15 || true
[ "${ERR:-0}" = "0" ]
