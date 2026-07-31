#!/bin/bash
# One-shot: force identity1230 java cmdline cache-names (beats config-server).
# Paste-friendly. Does NOT use helm — re-run if a helm upgrade resets command/args.
#
# Usage: ./apply-cache-cmdline.sh [kubeconfig]

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
NS=${NS:-idrepo1230}
DEPLOY=${DEPLOY:-identity1230}
CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'

set -euo pipefail

SCRIPT=$(cat <<EOF
set -euo pipefail
cd /home/mosip
loader="\${loader_path_env:-/home/mosip/additional_jars/}"
mod="\${current_module_env:-id-repository-identity-service}"
mkdir -p "\$loader"
[ -f "\$loader/kernel-ref-idobjectvalidator.jar" ] || wget -q "\${artifactory_url_env}/artifactory/libs-release-local/io/mosip/kernel/kernel-ref-idobjectvalidator/kernel-ref-idobjectvalidator.jar" -O "\$loader/kernel-ref-idobjectvalidator.jar" || true
[ -f "\$loader/kernel-auth-adapter.jar" ] || wget -q "\${iam_adapter_url_env}" -O "\$loader/kernel-auth-adapter.jar" || true
exec java \\
  -Dloader.path="\$loader" \\
  -Dspring.cloud.config.label="\${spring_config_label_env}" \\
  -Dspring.profiles.active="\${active_profile_env}" \\
  -Dspring.cloud.config.uri="\${spring_config_url_env}" \\
  -jar "\${mod}.jar" \\
  --spring.cloud.config.allow-override=true \\
  --spring.cloud.config.override-none=true \\
  --spring.cloud.config.override-system-properties=false \\
  --spring.cache.type=simple \\
  --spring.cache.cache-names=${CACHE_NAMES} \\
  --mosip.idrepo.cache.names=${CACHE_NAMES}
EOF
)

# Build JSON patch with python for safe escaping
PATCH=$(SCRIPT="$SCRIPT" python3 -c 'import json,os; s=os.environ["SCRIPT"]; print(json.dumps([
  {"op":"add","path":"/spec/template/spec/containers/0/command","value":["/bin/bash","-lc"]},
  {"op":"add","path":"/spec/template/spec/containers/0/args","value":[s]},
]))')

# Prefer replace if fields already exist
CUR=$(kubectl -n "$NS" get deploy "$DEPLOY" -o json)
PATCH=$(CUR="$CUR" SCRIPT="$SCRIPT" python3 - <<'PY'
import json, os
dep = json.loads(os.environ["CUR"])
script = os.environ["SCRIPT"]
c0 = dep["spec"]["template"]["spec"]["containers"][0]
ops = []
ops.append({
  "op": "replace" if "command" in c0 and c0["command"] is not None else "add",
  "path": "/spec/template/spec/containers/0/command",
  "value": ["/bin/bash", "-lc"],
})
# args may be null
has_args = bool(c0.get("args"))
ops.append({
  "op": "replace" if has_args else "add",
  "path": "/spec/template/spec/containers/0/args",
  "value": [script],
})
print(json.dumps(ops))
PY
)

echo "Patching $NS/$DEPLOY command+args ..."
kubectl -n "$NS" patch deployment "$DEPLOY" --type=json -p="$PATCH"

kubectl -n "$NS" set env deployment/"$DEPLOY" \
  SPRING_CLOUD_CONFIG_ALLOW_OVERRIDE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_NONE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false \
  SPRING_CACHE_TYPE=simple \
  SPRING_CACHE_CACHE_NAMES="$CACHE_NAMES"

echo "Waiting for rollout..."
kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=300s

echo
echo "=== verify deployment.command ==="
kubectl -n "$NS" get deploy "$DEPLOY" -o jsonpath='{.spec.template.spec.containers[0].command}{"\n"}'
echo "=== verify java cmdline ==="
sleep 8
JAVA_LINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'ps -o args -A | grep "[j]ava.*id-repository-identity" | head -1' || true)
echo "$JAVA_LINE"
echo "$JAVA_LINE" | grep -q Online_Verification_Partners

echo "OK — Online_Verification_Partners is on the java process."
echo "Next: sleep 40; then"
echo "  kubectl -n $NS logs deploy/$DEPLOY --since=2m | grep -c \"Cannot find cache named 'Online_Verification_Partners'\""
echo "(expect 0). Re-run this script after any helm upgrade of identity1230."
