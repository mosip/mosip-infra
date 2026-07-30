#!/bin/bash
# Stop identity1230 credential job failures:
#   Cannot find cache named 'Online_Verification_Partners'
#
# Why simple+cache-names failed on qa11new:
#   Env SPRING_CACHE_TYPE=simple and SPRING_CACHE_CACHE_NAMES were visible in the
#   pod, but MOSIP's CacheManager still had no named caches (Boot auto-config
#   does not populate a custom/empty manager). Credential issuance never reached
#   credentialrequest → mosip_credential1230 stayed stuck.
#
# Fix: spring.cache.type=none → NoOpCacheManager (any @Cacheable name succeeds).
# Prefer removing the simple override entirely if shared Redis is reachable.
#
# Usage: ./fix-cache.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=${NS:-idrepo1230}
CM=${CM:-idrepo1230-cache}

set -euo pipefail

echo "==> Remove config-server override that forces spring.cache.type=simple (if present)"
if kubectl -n "$NS" get cm idrepo1230-overrides >/dev/null 2>&1; then
  kubectl -n "$NS" get cm idrepo1230-overrides -o yaml \
    | sed '/SPRING_CLOUD_CONFIG_SERVER_OVERRIDES_SPRING_CACHE_TYPE/d' \
    | kubectl apply -f -
else
  echo "    (no idrepo1230-overrides CM — skip)"
fi

echo "==> Create/update ConfigMap $NS/$CM with SPRING_CACHE_TYPE=none"
kubectl -n "$NS" create configmap "$CM" \
  --from-literal=SPRING_CACHE_TYPE=none \
  --dry-run=client -o yaml | kubectl apply -f -

echo
echo "Ensure $CM is mounted on identity1230 (extraEnvVarsCM), then restart:"
cat <<EOF
# If not already mounted via helm values:
helm -n $NS upgrade identity1230 mosip/identity --reuse-values \\
  --set 'extraEnvVarsCM[0]=global' \\
  --set 'extraEnvVarsCM[1]=config-server-share' \\
  --set 'extraEnvVarsCM[2]=artifactory-share' \\
  --set 'extraEnvVarsCM[3]=idrepo1230-overrides' \\
  --set 'extraEnvVarsCM[4]=idrepo1230-rest-uris' \\
  --set 'extraEnvVarsCM[5]=$CM'

# Or inject env from CM then restart:
kubectl -n $NS set env deployment/identity1230 --from=configmap/$CM --overwrite
kubectl -n $NS rollout restart deployment/identity1230
kubectl -n $NS rollout status deployment/identity1230 --timeout=180s
EOF

echo
echo "Verify (expect 0):"
cat <<EOF
sleep 40
kubectl -n $NS logs deploy/identity1230 --since=2m \\
  | grep -c "Cannot find cache named 'Online_Verification_Partners'" || true

kubectl -n $NS logs deploy/identity1230 --since=2m \\
  | grep -E 'Cannot find cache named|PARTNERS_IDENTIFIED|requestgenerator' \\
  | tail -20
EOF
