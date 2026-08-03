#!/bin/bash
# Patch idrepo1230 service-to-service REST URIs so identity actually calls
# credentialrequest1230 / credential1230 (not default *.idrepo from config-server).
#
# Why: RestRequestBuilder caches mosip.idrepo.credential.request.rest.uri at startup.
# That property is already expanded from config-server to:
#   http://credentialrequest.idrepo/v1/credentialrequest/requestgenerator
# Overriding only mosip.idrepo.credrequest.generator.url does NOT change the cached URI.
#
# This script CREATES the ConfigMap AND applies SPRING_APPLICATION_JSON onto the
# four deployments (kubectl set env). Earlier versions only printed helm commands.
#
## Usage: ./patch-service-urls.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=${NS:-idrepo1230}
CM=${CM:-idrepo1230-rest-uris}
APPLY=${APPLY:-true}

set -euo pipefail

CACHE_NAMES='Online_Verification_Partners,id_attributes,uin_hash_salt,uin_encrypt_salt,DATASHARE_POLICIES,PARTNER_EXTRACTOR_FORMATS,topics,credential_transaction'
REST_JSON=$(cat <<EOF
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
  "spring.cache.type": "simple",
  "spring.cache.cache-names": "${CACHE_NAMES}",
  "mosip.idrepo.cache.names": "${CACHE_NAMES}"
}
EOF
)

REST_JSON_ONE_LINE=$(echo "$REST_JSON" | jq -c .)

echo "Creating/updating ConfigMap $NS/$CM ..."
kubectl -n "$NS" create configmap "$CM" \
  --from-literal=SPRING_APPLICATION_JSON="$REST_JSON_ONE_LINE" \
  --dry-run=client -o yaml | kubectl apply -f -

if [ "$APPLY" != "true" ]; then
  echo "APPLY=false — ConfigMap only. Set APPLY=true to push env onto deploys."
  exit 0
fi

echo
echo "Applying SPRING_APPLICATION_JSON onto identity/vid/credential/credentialrequest ..."
for dep in identity1230 vid1230 credential1230 credentialrequest1230; do
  if ! kubectl -n "$NS" get deploy "$dep" >/dev/null 2>&1; then
    echo "SKIP missing deploy $dep"
    continue
  fi
  # Direct env beats stale config-server expansion for RestRequestBuilder.
  kubectl -n "$NS" set env deployment/"$dep" \
    "SPRING_APPLICATION_JSON=$REST_JSON_ONE_LINE"
  echo "  set env on $dep"
done

echo
echo "Waiting for rollouts..."
for dep in identity1230 vid1230 credential1230 credentialrequest1230; do
  kubectl -n "$NS" get deploy "$dep" >/dev/null 2>&1 || continue
  kubectl -n "$NS" rollout status deployment/"$dep" --timeout=300s
done

echo
echo "NOTE: cache case-mismatch still needs ./apply-cache-cmdline.sh on identity1230"
echo "(SPRING_APPLICATION_JSON alone often loses to config-server for SimpleCacheConfig)."
echo
echo "Verify:"
echo "  ./diagnose-credential-path.sh"
echo "  kubectl -n $NS exec deploy/identity1230 -- printenv SPRING_APPLICATION_JSON | jq ."
