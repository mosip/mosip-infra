#!/bin/bash
# Force correct spring.cache.cache-names on identity1230 WITHOUT skipping BioSDK.
#
# MUST keep image ENTRYPOINT ./configure_start.sh (installs biosdk client).
# Only replace CMD via container args → configure_start.sh runs biosdk, then exec's our java.
#
# Usage: ./apply-cache-cmdline.sh [kubeconfig]

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
NS=${NS:-idrepo1230}
DEPLOY=${DEPLOY:-identity1230}
CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'

set -euo pipefail

echo "==> Build CMD wrapper (runs AFTER configure_start.sh biosdk install)"
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

echo "==> Patch deployment: REMOVE command (keep ENTRYPOINT), SET args only"
CUR=$(kubectl -n "$NS" get deploy "$DEPLOY" -o json)
PATCH=$(CUR="$CUR" SCRIPT="$SCRIPT" python3 - <<'PY'
import json, os
dep = json.loads(os.environ["CUR"])
script = os.environ["SCRIPT"]
c0 = dep["spec"]["template"]["spec"]["containers"][0]
ops = []
# Critical: do NOT override command — image ENTRYPOINT must stay ./configure_start.sh
if "command" in c0 and c0["command"] is not None:
    ops.append({"op": "remove", "path": "/spec/template/spec/containers/0/command"})
has_args = bool(c0.get("args"))
ops.append({
  "op": "replace" if has_args else "add",
  "path": "/spec/template/spec/containers/0/args",
  "value": ["/bin/bash", "-lc", script],
})
print(json.dumps(ops))
PY
)

echo "Patch: $PATCH" | head -c 200; echo "..."
kubectl -n "$NS" patch deployment "$DEPLOY" --type=json -p="$PATCH"

# Prefer app args over JAVA_TOOL_OPTIONS for cache names (avoid double-binding confusion)
kubectl -n "$NS" set env deployment/"$DEPLOY" JAVA_TOOL_OPTIONS- 2>/dev/null || true
kubectl -n "$NS" set env deployment/"$DEPLOY" \
  SPRING_CLOUD_CONFIG_ALLOW_OVERRIDE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_NONE=true \
  SPRING_CLOUD_CONFIG_OVERRIDE_SYSTEM_PROPERTIES=false \
  SPRING_CACHE_TYPE=simple \
  SPRING_CACHE_CACHE_NAMES="$CACHE_NAMES"

echo "==> Rollout"
kubectl -n "$NS" rollout status deployment/"$DEPLOY" --timeout=300s

echo "==> Verify"
echo -n "command (must be empty): "
kubectl -n "$NS" get deploy "$DEPLOY" -o jsonpath='{.spec.template.spec.containers[0].command}{"\n"}'
echo -n "args present: "
kubectl -n "$NS" get deploy "$DEPLOY" -o json | python3 -c 'import json,sys; a=json.load(sys.stdin)["spec"]["template"]["spec"]["containers"][0].get("args") or []; print(bool(a), "Online_Verification_Partners" in " ".join(a))'

sleep 15
# wait until Running (biosdk download takes a bit)
for i in 1 2 3 4 5 6 7 8 9 10; do
  PHASE=$(kubectl -n "$NS" get pods -l app.kubernetes.io/name=identity,app.kubernetes.io/instance=identity1230 -o jsonpath='{.items[0].status.phase}' 2>/dev/null || \
          kubectl -n "$NS" get pods -l app=identity1230 -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo Unknown)
  echo "pod phase: $PHASE"
  [ "$PHASE" = "Running" ] && break
  sleep 10
done

JAVA_LINE=$(kubectl -n "$NS" exec deploy/"$DEPLOY" -- bash -lc 'ps -o args -A | grep "[j]ava.*id-repository-identity" | head -1' 2>/dev/null || true)
echo "JAVA: $JAVA_LINE"
echo "$JAVA_LINE" | grep -q Online_Verification_Partners
echo "OK: cache-names on java AND biosdk entrypoint preserved"

echo "==> Cache error count (expect 0 after ~45s)"
sleep 45
kubectl -n "$NS" logs deploy/"$DEPLOY" --since=2m 2>/dev/null \
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || echo 0
