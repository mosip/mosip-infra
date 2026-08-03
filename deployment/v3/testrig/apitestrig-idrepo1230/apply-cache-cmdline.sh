#!/bin/bash
# Unblock identity1230 credential notify on qa11new (cache name case mismatch).
#
# id-repository v1.2.3.0 PartnerServiceManager uses:
#   @Cacheable("Online_Verification_Partners")
# qa11new config has lowercase:
#   mosip.idrepo.cache.names=...,online_verification_partners,...
#   spring.cache.cache-names=${mosip.idrepo.cache.names}
#
# v1.2.3.0 has NO SimpleCacheConfig — Spring Boot ConcurrentMapCacheManager
# is locked to spring.cache.cache-names. Overriding only mosip.idrepo.cache.names
# does nothing. release-1.2.3.x images that DO have SimpleCacheConfig read
# mosip.idrepo.cache.names (+ size/expire maps) instead.
#
# Default MODE=noop:
#   --spring.cache.type=none → NoOpCacheManager (any cache name works; QA-safe)
# MODE=names:
#   force PascalCase on BOTH spring.cache.cache-names and mosip.idrepo.cache.names
#
# Keeps image ENTRYPOINT ./configure_start.sh (biosdk) — only overrides args/CMD.
#
# Usage:
#   ./apply-cache-cmdline.sh [kubeconfig]
#   MODE=names ./apply-cache-cmdline.sh

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
NS=${NS:-idrepo1230}
DEPLOY=${DEPLOY:-identity1230}
MODE=${MODE:-noop}   # noop | names

CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'
CACHE_SIZE_MAP="{ 'Online_Verification_Partners': 200, 'id_attributes': 200, 'uin_hash_salt': 100, 'uin_encrypt_salt': 100, 'DATASHARE_POLICIES': 200, 'PARTNER_EXTRACTOR_FORMATS': 200, 'topics': 200, 'credential_transaction': 200, 'online_verification_partners': 200, 'partner_extractor_formats': 200, 'datashare_policies': 200 }"
CACHE_EXPIRE_MAP="{ 'Online_Verification_Partners': 86400, 'id_attributes': 86400, 'uin_hash_salt': 86400, 'uin_encrypt_salt': 86400, 'DATASHARE_POLICIES': 86400, 'PARTNER_EXTRACTOR_FORMATS': 86400, 'topics': 86400, 'credential_transaction': 86400, 'online_verification_partners': 86400, 'partner_extractor_formats': 86400, 'datashare_policies': 86400 }"

set -euo pipefail

if [ "$MODE" != "noop" ] && [ "$MODE" != "names" ]; then
  echo "MODE must be noop or names (got: $MODE)" >&2
  exit 1
fi

# Build the in-container start script with python (quoted heredoc — no bash ${{}} expansion).
SCRIPT=$(
MODE="$MODE" \
CACHE_NAMES="$CACHE_NAMES" \
CACHE_SIZE_MAP="$CACHE_SIZE_MAP" \
CACHE_EXPIRE_MAP="$CACHE_EXPIRE_MAP" \
python3 - <<'PY'
import os
mode = os.environ["MODE"]
names = os.environ["CACHE_NAMES"]
size = os.environ["CACHE_SIZE_MAP"]
expire = os.environ["CACHE_EXPIRE_MAP"]

if mode == "noop":
    prop_body = "spring.cache.type=none\n"
    # type=none → NoOpCacheManager; cache name case becomes irrelevant.
    java_cache_flags = """  -Dspring.cache.type=none \\
  -Dspring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties \\"""
    app_cache_flags = """  --spring.cache.type=none \\
  --spring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties"""
else:
    prop_body = f"""spring.cache.type=simple
spring.cache.cache-names={names}
mosip.idrepo.cache.names={names}
mosip.idrepo.cache.size={size}
mosip.idrepo.cache.expire-in-seconds={expire}
"""
    # Set BOTH properties: Boot ConcurrentMapCacheManager uses spring.cache.cache-names;
    # SimpleCacheConfig (newer 1.2.3.x) uses mosip.idrepo.cache.names + maps.
    java_cache_flags = f"""  -Dspring.cache.type=simple \\
  -Dspring.cache.cache-names={names} \\
  -Dmosip.idrepo.cache.names={names} \\
  -Dspring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties \\"""
    app_cache_flags = f"""  --spring.cache.type=simple \\
  --spring.cache.cache-names={names} \\
  --mosip.idrepo.cache.names={names} \\
  --spring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties"""

# Triple-quoted template: {{ → literal { for the pod shell; {names} filled by python.
print(f'''set -euo pipefail
cd /home/mosip
loader="${{loader_path_env:-/home/mosip/additional_jars/}}"
mod="${{current_module_env:-id-repository-identity-service}}"
mkdir -p "$loader" /home/mosip/config
[ -f "$loader/kernel-ref-idobjectvalidator.jar" ] || wget -q "${{artifactory_url_env}}/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/kernel-ref-idobjectvalidator.jar" -O "$loader/kernel-ref-idobjectvalidator.jar" || true
[ -f "$loader/kernel-auth-adapter.jar" ] || wget -q "${{iam_adapter_url_env}}" -O "$loader/kernel-auth-adapter.jar" || true

cat > /home/mosip/config/cache-override.properties <<'PROP'
{prop_body}PROP

# -D* BEFORE -jar so they are JVM system properties. App args (--*) beat config-server
# for most Spring Boot versions even when allowOverride is not granted remotely.
exec java \\
  -Dloader.path="$loader" \\
  -Dspring.cloud.config.label="${{spring_config_label_env}}" \\
  -Dspring.profiles.active="${{active_profile_env}}" \\
  -Dspring.cloud.config.uri="${{spring_config_url_env}}" \\
  -Dspring.cloud.config.allow-override=true \\
  -Dspring.cloud.config.override-none=true \\
  -Dspring.cloud.config.override-system-properties=false \\
{java_cache_flags}
  -jar "${{mod}}.jar" \\
  --spring.cloud.config.allow-override=true \\
  --spring.cloud.config.override-none=true \\
  --spring.cloud.config.override-system-properties=false \\
{app_cache_flags}
''')
PY
)

if [ "$MODE" = "noop" ]; then
  echo "$SCRIPT" | grep -q '\-Dspring.cache.type=none'
else
  echo "$SCRIPT" | grep -q '\-Dspring.cache.cache-names=Online_Verification_Partners'
  echo "$SCRIPT" | grep -q '\-Dmosip.idrepo.cache.names=Online_Verification_Partners'
fi

echo "==> Patch deploy $DEPLOY (MODE=$MODE; ENTRYPOINT kept; args = CMD wrapper)"
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
if [ "$MODE" = "noop" ]; then
  kubectl -n "$NS" set env deployment/"$DEPLOY" \
    SPRING_CLOUD_CONFIG_ALLOW_OVERRIDE=true \
    SPRING_CLOUD_CONFIG_OVERRIDE_NONE=true \
    SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false \
    SPRING_CACHE_TYPE=none \
    MOSIP_IDREPO_CACHE_NAMES- \
    SPRING_CACHE_CACHE_NAMES-
else
  kubectl -n "$NS" set env deployment/"$DEPLOY" \
    SPRING_CLOUD_CONFIG_ALLOW_OVERRIDE=true \
    SPRING_CLOUD_CONFIG_OVERRIDE_NONE=true \
    SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false \
    SPRING_CACHE_TYPE=simple \
    "SPRING_CACHE_CACHE_NAMES=$CACHE_NAMES" \
    "MOSIP_IDREPO_CACHE_NAMES=$CACHE_NAMES"
fi

kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=300s

echo "==> Verify java cmdline"
sleep 15
JAVA_LINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'ps -o args -A | grep "[j]ava.*id-repository-identity" | head -1' || true)
echo "$JAVA_LINE"
if [ "$MODE" = "noop" ]; then
  if ! echo "$JAVA_LINE" | grep -qE '\-Dspring.cache.type=none|--spring.cache.type=none'; then
    echo "ERROR: java cmdline missing spring.cache.type=none"
    exit 1
  fi
  echo "OK: spring.cache.type=none on cmdline"
else
  if ! echo "$JAVA_LINE" | grep -q '\-Dspring.cache.cache-names=Online_Verification_Partners'; then
    echo "ERROR: java cmdline missing -Dspring.cache.cache-names"
    exit 1
  fi
  echo "OK: spring.cache.cache-names set"
fi

echo "==> Confirm properties file inside pod"
kubectl -n "$NS" exec deploy/"$DEPLOY" -- cat /home/mosip/config/cache-override.properties || true

echo "==> Error count (expect 0)"
sleep 50
ERR=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
echo "error count: $ERR"
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -E 'PARTNERS_IDENTIFIED|Caching Online_Verification|BIO_SDK|Application run failed|NoOpCacheManager|SimpleCache' | tail -15 || true
[ "${ERR:-0}" = "0" ]
