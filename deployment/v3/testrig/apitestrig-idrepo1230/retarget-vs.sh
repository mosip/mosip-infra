#!/bin/bash
# Point existing api-internal idrepo VirtualService routes at the idrepo1230 services.
# Apitestrig keeps ENV_ENDPOINT=https://api-internal.<env> (authmanager etc. stay on the live cluster).
# Only idrepo path prefixes are retargeted to the parallel stack.
## Usage: ./retarget-vs.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

OLD_NS=${OLD_NS:-idrepo}
NEW_NS=${NEW_NS:-idrepo1230}
GATEWAY=${GATEWAY:-istio-system/internal}

# Helm release names in idrepo1230 (from parallel install)
IDENTITY_SVC=${IDENTITY_SVC:-identity1230}
CREDENTIAL_SVC=${CREDENTIAL_SVC:-credential1230}
CREDENTIALREQUEST_SVC=${CREDENTIALREQUEST_SVC:-credentialrequest1230}
VID_SVC=${VID_SVC:-vid1230}

set -euo pipefail

echo "Retargeting idrepo VirtualServices"
echo "  old namespace (VS to patch): $OLD_NS"
echo "  new services namespace:      $NEW_NS"
echo "  gateway:                    $GATEWAY"
echo

# Map: vs_name|destination_service|uri_prefix
ROUTES=(
  "identity|${IDENTITY_SVC}|/idrepository/v1/identity"
  "credential|${CREDENTIAL_SVC}|/v1/credentialservice"
  "credentialrequest|${CREDENTIALREQUEST_SVC}|/v1/credentialrequest"
  "vid|${VID_SVC}|/idrepository/v1"
)

confirm_services() {
  local svc=$1
  if ! kubectl -n "$NEW_NS" get svc "$svc" >/dev/null 2>&1; then
    echo "ERROR: Service $svc not found in namespace $NEW_NS"
    echo "Available services:"
    kubectl -n "$NEW_NS" get svc
    exit 1
  fi
  echo "OK: $svc.$NEW_NS"
}

echo "Checking target services exist..."
for route in "${ROUTES[@]}"; do
  IFS='|' read -r _ svc _ <<<"$route"
  confirm_services "$svc"
done
echo

patch_or_create_vs() {
  local vs_name=$1
  local dest_svc=$2
  local prefix=$3
  local dest_host="${dest_svc}.${NEW_NS}.svc.cluster.local"

  if kubectl -n "$OLD_NS" get virtualservice "$vs_name" >/dev/null 2>&1; then
    echo "Patching VirtualService $OLD_NS/$vs_name -> $dest_host (prefix $prefix)"
    # Backup first
    mkdir -p ./vs-backup
    kubectl -n "$OLD_NS" get virtualservice "$vs_name" -o yaml > "./vs-backup/${vs_name}.yaml"
    kubectl -n "$OLD_NS" patch virtualservice "$vs_name" --type=json -p="[
      {\"op\":\"replace\",\"path\":\"/spec/http/0/route/0/destination/host\",\"value\":\"${dest_host}\"}
    ]"
  else
    echo "VirtualService $OLD_NS/$vs_name not found; creating one that routes to $dest_host"
    cat <<EOF | kubectl apply -f -
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ${vs_name}
  namespace: ${OLD_NS}
spec:
  hosts:
  - "*"
  gateways:
  - ${GATEWAY}
  http:
  - match:
    - uri:
        prefix: ${prefix}
    route:
    - destination:
        host: ${dest_host}
        port:
          number: 80
    headers:
      request:
        set:
          x-forwarded-proto: https
EOF
  fi
}

for route in "${ROUTES[@]}"; do
  IFS='|' read -r vs_name dest_svc prefix <<<"$route"
  patch_or_create_vs "$vs_name" "$dest_svc" "$prefix"
done

echo
echo "Done. Current VirtualServices in $OLD_NS:"
kubectl -n "$OLD_NS" get virtualservice -o wide

echo
echo "Also check for conflicting VS in $NEW_NS (same path prefixes on same gateway):"
kubectl -n "$NEW_NS" get virtualservice 2>/dev/null || echo "(none)"

echo
echo "NOTE: If $NEW_NS also has VirtualServices with the same URI prefixes,"
echo "disable them to avoid ambiguous routing, e.g.:"
echo "  kubectl -n $NEW_NS delete virtualservice --all"
echo "Backups of patched VS (if any) are under ./vs-backup/"
echo
echo "Quick health checks (from a pod / wireguard):"
echo "  curl -sk https://\$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')/idrepository/v1/identity/actuator/health"
echo "  curl -sk https://\$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')/v1/credentialservice/actuator/health"
