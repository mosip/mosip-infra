#!/bin/bash
# Patch idrepo1230 service-to-service REST URIs so identity actually calls
# credentialrequest1230 / credential1230 (not default *.idrepo from config-server).
#
# Why: RestRequestBuilder caches mosip.idrepo.credential.request.rest.uri at startup.
# That property is already expanded from config-server to:
#   http://credentialrequest.idrepo/v1/credentialrequest/requestgenerator
# Overriding only mosip.idrepo.credrequest.generator.url does NOT change the cached URI.
#
## Usage: ./patch-service-urls.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=${NS:-idrepo1230}
CM=${CM:-idrepo1230-rest-uris}

set -euo pipefail

# Build SPRING_APPLICATION_JSON so hyphenated keys bind correctly.
# IMPORTANT: parallel stacks often set spring.cache.type=simple. That left an empty
# CacheManager on qa11new even with SPRING_CACHE_CACHE_NAMES set — identity then
# threw "Cannot find cache named 'Online_Verification_Partners'" and never called
# credentialrequest. Use type=none (NoOpCacheManager) or shared Redis; see fix-cache.sh.
REST_JSON=$(cat <<'EOF'
{
  "mosip.idrepo.credrequest.generator.url": "http://credentialrequest1230.idrepo1230",
  "mosip.idrepo.credential.service.url": "http://credential1230.idrepo1230",
  "mosip.idrepo.identity.url": "http://identity1230.idrepo1230",
  "mosip.idrepo.vid.url": "http://vid1230.idrepo1230",
  "mosip.idrepo.credential.request.rest.uri": "http://credentialrequest1230.idrepo1230/v1/credentialrequest/requestgenerator",
  "mosip.idrepo.credential.cancel-request.rest.uri": "http://credentialrequest1230.idrepo1230/v1/credentialrequest/cancel/{requestId}",
  "mosip.idrepo.credential-request-v2.rest.uri": "http://credentialrequest1230.idrepo1230/v1/credentialrequest/v2/requestgenerator/{rid}",
  "CRDENTIALSERVICE": "http://credential1230.idrepo1230/v1/credentialservice/issue",
  "CALLBACKURL": "http://credentialrequest1230.idrepo1230/v1/credentialrequest/callback/notifyStatus",
  "spring.cache.type": "none"
}
EOF
)

# Compact JSON to a single line for the ConfigMap
REST_JSON_ONE_LINE=$(echo "$REST_JSON" | jq -c .)

echo "Creating/updating ConfigMap $NS/$CM with SPRING_APPLICATION_JSON..."
kubectl -n "$NS" create configmap "$CM" \
  --from-literal=SPRING_APPLICATION_JSON="$REST_JSON_ONE_LINE" \
  --dry-run=client -o yaml | kubectl apply -f -

echo
echo "Mount $CM on identity1230 / vid1230 / credential1230 / credentialrequest1230"
echo "(keep existing CMs; add this as an extraEnvVarsCM entry)."
echo
echo "Example for identity1230 (quote --set for zsh):"
cat <<EOF
helm -n $NS upgrade identity1230 mosip/identity --reuse-values \\
  --set 'extraEnvVarsCM[0]=global' \\
  --set 'extraEnvVarsCM[1]=config-server-share' \\
  --set 'extraEnvVarsCM[2]=artifactory-share' \\
  --set 'extraEnvVarsCM[3]=idrepo1230-overrides' \\
  --set 'extraEnvVarsCM[4]=$CM'

helm -n $NS upgrade vid1230 mosip/vid --reuse-values \\
  --set 'extraEnvVarsCM[0]=global' \\
  --set 'extraEnvVarsCM[1]=config-server-share' \\
  --set 'extraEnvVarsCM[2]=artifactory-share' \\
  --set 'extraEnvVarsCM[3]=idrepo1230-overrides' \\
  --set 'extraEnvVarsCM[4]=$CM'

helm -n $NS upgrade credential1230 mosip/credential --reuse-values \\
  --set 'extraEnvVarsCM[0]=global' \\
  --set 'extraEnvVarsCM[1]=config-server-share' \\
  --set 'extraEnvVarsCM[2]=artifactory-share' \\
  --set 'extraEnvVarsCM[3]=idrepo1230-overrides' \\
  --set 'extraEnvVarsCM[4]=idrepo1230-spring-datasource' \\
  --set 'extraEnvVarsCM[5]=$CM'

helm -n $NS upgrade credentialrequest1230 mosip/credentialrequest --reuse-values \\
  --set 'extraEnvVarsCM[0]=global' \\
  --set 'extraEnvVarsCM[1]=config-server-share' \\
  --set 'extraEnvVarsCM[2]=artifactory-share' \\
  --set 'extraEnvVarsCM[3]=idrepo1230-overrides' \\
  --set 'extraEnvVarsCM[4]=idrepo1230-spring-datasource' \\
  --set 'extraEnvVarsCM[5]=$CM'

kubectl -n $NS rollout restart deploy/identity1230 deploy/vid1230 deploy/credential1230 deploy/credentialrequest1230
kubectl -n $NS rollout status deploy/identity1230
kubectl -n $NS rollout status deploy/credentialrequest1230
EOF

echo
echo "After rollout, verify effective REST URI (must contain credentialrequest1230):"
cat <<'EOF'
API=$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')
curl -sk "https://$API/idrepository/v1/identity/actuator/env" \
  | jq -r '
      .. | objects | to_entries[]?
      | select(.key == "mosip.idrepo.credential.request.rest.uri"
            or .key == "mosip.idrepo.credrequest.generator.url")
      | "\(.key)=\(.value.value // .value)"
    '
EOF
