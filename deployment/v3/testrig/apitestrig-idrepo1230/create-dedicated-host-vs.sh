#!/bin/bash
# Create a dedicated Istio VirtualService host for idrepo1230 so traffic does NOT
# share api-internal routes with the live idrepo stack.
#
# After DNS/Gateway include the host, point apitestrig at:
#   ENV_ENDPOINT=https://<DEDICATED_HOST> ./install.sh
#
# This VS routes idrepo1230 paths to the parallel stack, and proxies common
# shared deps (authmanager/keymanager/...) to the live namespaces so a single
# ENV_ENDPOINT still works for idrepo-only apitestrig.
#
# Usage:
#   DEDICATED_HOST=api-idrepo1230.qa11new.mosip.net ./create-dedicated-host-vs.sh [kubeconfig]
#
# Prerequisites:
#   1) DNS A/CNAME (or CoreDNS hosts) for DEDICATED_HOST → same LB as api-internal
#      Run ./print-dns-hint.sh
#   2) Istio Gateway (default: istio-system/internal) lists DEDICATED_HOST
#      Run ./ensure-dedicated-gateway-host.sh

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi

NS=${NS:-idrepo1230}
GATEWAY=${GATEWAY:-istio-system/internal}
DEDICATED_HOST=${DEDICATED_HOST:-}

IDENTITY_SVC=${IDENTITY_SVC:-identity1230}
CREDENTIAL_SVC=${CREDENTIAL_SVC:-credential1230}
CREDENTIALREQUEST_SVC=${CREDENTIALREQUEST_SVC:-credentialrequest1230}
VID_SVC=${VID_SVC:-vid1230}

# Live shared services (used for non-idrepo paths on the dedicated host)
AUTHMANAGER_DEST=${AUTHMANAGER_DEST:-authmanager.kernel.svc.cluster.local}
KEYMANAGER_DEST=${KEYMANAGER_DEST:-keymanager.keymanager.svc.cluster.local}
MASTERDATA_DEST=${MASTERDATA_DEST:-masterdata.masterdata.svc.cluster.local}
AUDIT_DEST=${AUDIT_DEST:-auditmanager.kernel.svc.cluster.local}
NOTIFIER_DEST=${NOTIFIER_DEST:-notifier.kernel.svc.cluster.local}
OTPMANAGER_DEST=${OTPMANAGER_DEST:-otpmanager.kernel.svc.cluster.local}
PRIDGENERATOR_DEST=${PRIDGENERATOR_DEST:-pridgenerator.kernel.svc.cluster.local}
RIDGENERATOR_DEST=${RIDGENERATOR_DEST:-ridgenerator.kernel.svc.cluster.local}
IDGENERATOR_DEST=${IDGENERATOR_DEST:-idgenerator.kernel.svc.cluster.local}
DATASHARE_DEST=${DATASHARE_DEST:-datashare.datashare.svc.cluster.local}
BIOSDK_DEST=${BIOSDK_DEST:-biosdk-service.biosdk.svc.cluster.local}
WEBSUB_DEST=${WEBSUB_DEST:-websub.websub.svc.cluster.local}
# Partner stack (idrepo apitestrig healthCheckEndpoint.properties includes these)
PARTNERMANAGER_DEST=${PARTNERMANAGER_DEST:-pms-partner.pms.svc.cluster.local}
POLICYMANAGER_DEST=${POLICYMANAGER_DEST:-pms-policy.pms.svc.cluster.local}

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
  # --- parallel idrepo1230 stack (must be listed before shared /idrepository/v1) ---
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
  # --- shared live deps so ENV_ENDPOINT can be the dedicated host ---
  - match:
    - uri:
        prefix: /v1/authmanager
    route:
    - destination:
        host: ${AUTHMANAGER_DEST}
  - match:
    - uri:
        prefix: /v1/keymanager
    route:
    - destination:
        host: ${KEYMANAGER_DEST}
  - match:
    - uri:
        prefix: /v1/masterdata
    route:
    - destination:
        host: ${MASTERDATA_DEST}
  - match:
    - uri:
        prefix: /v1/auditmanager
    route:
    - destination:
        host: ${AUDIT_DEST}
  - match:
    - uri:
        prefix: /v1/notifier
    route:
    - destination:
        host: ${NOTIFIER_DEST}
  - match:
    - uri:
        prefix: /v1/otpmanager
    route:
    - destination:
        host: ${OTPMANAGER_DEST}
  - match:
    - uri:
        prefix: /v1/pridgenerator
    route:
    - destination:
        host: ${PRIDGENERATOR_DEST}
  - match:
    - uri:
        prefix: /v1/ridgenerator
    route:
    - destination:
        host: ${RIDGENERATOR_DEST}
  - match:
    - uri:
        prefix: /v1/idgenerator
    route:
    - destination:
        host: ${IDGENERATOR_DEST}
  - match:
    - uri:
        prefix: /v1/partnermanager
    route:
    - destination:
        host: ${PARTNERMANAGER_DEST}
  - match:
    - uri:
        prefix: /v1/policymanager
    route:
    - destination:
        host: ${POLICYMANAGER_DEST}
  - match:
    - uri:
        prefix: /v1/datashare
    route:
    - destination:
        host: ${DATASHARE_DEST}
  - match:
    - uri:
        prefix: /biosdk-service
    route:
    - destination:
        host: ${BIOSDK_DEST}
  - match:
    - uri:
        prefix: /hub
    route:
    - destination:
        host: ${WEBSUB_DEST}
EOF

echo
echo "Done. Next steps (DNS is required — UnknownHostException without it):"
echo "  1) ./print-dns-hint.sh"
echo "  2) ./ensure-dedicated-gateway-host.sh"
echo "  3) ./check-health-deps.sh          # curls idrepo health endpoints (skip drivers)"
echo "  4) ENV_ENDPOINT=https://$DEDICATED_HOST ./install.sh"
echo "  5) after a run: ./diagnose-skips.sh # SkipException reason histogram from pod logs"
echo
echo "Service-to-service (identity→credentialrequest) still uses in-cluster DNS"
echo "  credentialrequest1230.idrepo1230 — run ./patch-service-urls.sh if needed."
echo "That is separate from the public/dedicated host."
