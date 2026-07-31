#!/bin/bash
# Force correct cache names on identity1230 (keep ENTRYPOINT/biosdk).
#
# Writes a properties file inside the container start script so comma-separated
# spring.cache.cache-names bind correctly (Boot 2.x cmdline commas are unreliable).
# Also passes indexed --spring.cache.cache-names[n]=... as backup.
#
# Usage: ./apply-cache-cmdline.sh [kubeconfig]

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
NS=${NS:-idrepo1230}
DEPLOY=${DEPLOY:-identity1230}
CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'

set -euo pipefail

# Indexed cmdline form (Boot list binding)
INDEXED=$(CACHE_NAMES="$CACHE_NAMES" python3 - <<'PY'
names = __import__("os").environ["CACHE_NAMES"].split(",")
# Quote each flag so bash does not glob cache-names[0]
print(" \\\n  ".join(f"'--spring.cache.cache-names[{i}]={n}'" for i,n in enumerate(names)))
PY
)

SCRIPT=$(CACHE_NAMES="$CACHE_NAMES" INDEXED="$INDEXED" python3 - <<'PY'
import os
names = os.environ["CACHE_NAMES"]
indexed = os.environ["INDEXED"]
print(f'''set -euo pipefail
cd /home/mosip
loader="${{loader_path_env:-/home/mosip/additional_jars/}}"
mod="${{current_module_env:-id-repository-identity-service}}"
mkdir -p "$loader" /home/mosip/config
[ -f "$loader/kernel-ref-idobjectvalidator.jar" ] || wget -q "${{artifactory_url_env}}/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/kernel-ref-idobjectvalidator.jar" -O "$loader/kernel-ref-idobjectvalidator.jar" || true
[ -f "$loader/kernel-auth-adapter.jar" ] || wget -q "${{iam_adapter_url_env}}" -O "$loader/kernel-auth-adapter.jar" || true

# Properties file: reliable List binding for cache-names
cat > /home/mosip/config/cache-override.properties <<'PROP'
spring.cache.type=simple
spring.cache.cache-names={names}
mosip.idrepo.cache.names={names}
PROP

exec java \\
  -Dloader.path="$loader" \\
  -Dspring.cloud.config.label="${{spring_config_label_env}}" \\
  -Dspring.profiles.active="${{active_profile_env}}" \\
  -Dspring.cloud.config.uri="${{spring_config_url_env}}" \\
  -jar "${{mod}}.jar" \\
  --spring.cloud.config.allow-override=true \\
  --spring.cloud.config.override-none=true \\
  --spring.cloud.config.override-system-properties=false \\
  --spring.config.additional-location=optional:file:/home/mosip/config/cache-override.properties \\
  --spring.cache.type=simple \\
  {indexed} \\
  --mosip.idrepo.cache.names={names}
''')
PY
)

echo "==> Patch: remove command (keep ENTRYPOINT), set args"
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
  "SPRING_CACHE_CACHE_NAMES=$CACHE_NAMES" \
  "SPRING_CONFIG_ADDITIONAL_LOCATION=optional:file:/home/mosip/config/cache-override.properties"

kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=300s

echo "==> Verify java has indexed cache-names or properties file path"
sleep 12
JAVA_LINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'ps -o args -A | grep "[j]ava.*id-repository-identity" | head -1' || true)
echo "$JAVA_LINE"
echo "$JAVA_LINE" | grep -q 'Online_Verification_Partners'
echo "$JAVA_LINE" | grep -q 'cache-override.properties\|cache-names\[0\]'
echo "OK"

echo "==> Error count (expect 0)"
sleep 45
ERR=$(kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true)
echo "error count: $ERR"
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -E 'PARTNERS_IDENTIFIED|Caching Online_Verification|requestgenerator' | tail -10 || true
[ "${ERR:-0}" = "0" ]
