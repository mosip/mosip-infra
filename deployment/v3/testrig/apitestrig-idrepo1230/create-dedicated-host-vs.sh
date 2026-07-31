#!/bin/bash
# Create a dedicated Istio VirtualService host for idrepo1230 so traffic does NOT
# share api-internal routes with the live idrepo stack.
#
# After DNS/Gateway include the host, point apitestrig at:
#   ENV_ENDPOINT=https://<DEDICATED_HOST>
# (or keep shared ENV_ENDPOINT for auth and only override idrepo base URLs if your
# testrig supports that).
#
# Usage:
#   DEDICATED_HOST=api-idrepo1230.qa11new.mosip.net ./create-dedicated-host-vs.sh [kubeconfig]
#
# Prerequisites:
#   1) DNS A/CNAME for DEDICATED_HOST → same LB as api-internal (or your ingress IP)
#   2) Istio Gateway (default: istio-system/internal) lists DEDICATED_HOST in servers.hosts
#      OR use a dedicated Gateway (set GATEWAY=idrepo1230/idrepo1230-gateway)

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi

NS=${NS:-idrepo1230}
GATEWAY=${GATEWAY:-istio-system/internal}
DEDICATED_HOST=${DEDICATED_HOST:-}

IDENTITY_SVC=${IDENTITY_SVC:-identity1230}
CREDENTIAL_SVC=${CREDENTIAL_SVC:-credential1230}
CREDENTIALREQUEST_SVC=${CREDENTIALREQUEST_SVC:-credentialrequest1230}
VID_SVC=${VID_SVC:-vid1230}

set -euo pipefail

if [ -z "$DEDICATED_HOST" ]; then
  API=$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}' 2>/dev/null || true)
  if [ -n "$API" ]; then
    # api-internal.qa11new.mosip.net → api-idrepo1230.qa11new.mosip.net
    DEDICATED_HOST=$(echo "$API" | sed 's/^api-internal\./api-idrepo1230./')
  fi
fi

if [ -z "$DEDICATED_HOST" ]; then
  echo "Set DEDICATED_HOST=api-idrepo1230.<env>.mosip.net"
  exit 1
fi

echo "Creating dedicated idrepo1230 VirtualService"
echo "  host:    $DEDICATED_HOST"
echo "  gateway: $GATEWAY"
echo "  ns:      $NS"
echo

for svc in "$IDENTITY_SVC" "$CREDENTIAL_SVC" "$CREDENTIALREQUEST_SVC" "$VID_SVC"; do
  kubectl -n "$NS" get svc "$svc" >/dev/null
done

# Optional: remove conflicting VS in this NS that use hosts: ["*"] with same prefixes
echo "NOTE: If $NS already has VS with hosts ['*'] for these paths, delete or narrow them:"
echo "  kubectl -n $NS get virtualservice"
echo

cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: idrepo1230-dedicated
  namespace: ${NS}
spec:
  hosts:
  - ${DEDICATED_HOST}
  gateways:
  - ${GATEWAY}
  http:
  - match:
    - uri:
        prefix: /idrepository/v1/identity
    route:
    - destination:
        host: ${IDENTITY_SVC}.${NS}.svc.cluster.local
  - match:
    - uri:
        prefix: /v1/credentialservice
    route:
    - destination:
        host: ${CREDENTIAL_SVC}.${NS}.svc.cluster.local
  - match:
    - uri:
        prefix: /v1/credentialrequest
    route:
    - destination:
        host: ${CREDENTIALREQUEST_SVC}.${NS}.svc.cluster.local
  - match:
    - uri:
        prefix: /idrepository/v1
    route:
    - destination:
        host: ${VID_SVC}.${NS}.svc.cluster.local
EOF

echo
echo "Done. Next steps:"
echo "  1) Ensure Gateway $GATEWAY includes host $DEDICATED_HOST"
echo "  2) DNS: $DEDICATED_HOST → ingress / load balancer"
echo "  3) Smoke:"
echo "       curl -sk https://$DEDICATED_HOST/idrepository/v1/identity/actuator/health"
echo "  4) Point idrepo apitestrig at this host (install.sh ENV_ENDPOINT or values)."
echo
echo "Service-to-service (identity→credentialrequest) still uses in-cluster DNS"
echo "  credentialrequest1230.idrepo1230 — run ./patch-service-urls.sh if needed."
echo "That is separate from the public/dedicated host."
