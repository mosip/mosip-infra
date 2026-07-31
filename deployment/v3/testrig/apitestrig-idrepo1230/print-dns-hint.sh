#!/bin/bash
# Print the LB/ingress IP that api-idrepo1230 DNS must point at.
# Usage: ./print-dns-hint.sh [kubeconfig]

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
DEDICATED_HOST=${DEDICATED_HOST:-api-idrepo1230.qa11new.mosip.net}
API=$(kubectl -n default get cm global -o jsonpath='{.data.mosip-api-internal-host}')

set -euo pipefail

echo "Shared API host:     $API"
echo "Dedicated API host:  $DEDICATED_HOST"
echo

echo "==> Resolve shared host (from this machine)"
getent hosts "$API" 2>/dev/null || host "$API" 2>/dev/null || nslookup "$API" 2>/dev/null || echo "(could not resolve $API here)"

echo
echo "==> Ingress / LB candidates (istio-system)"
kubectl -n istio-system get svc -o wide 2>/dev/null | egrep -i 'NAME|ingress|gateway|istio' || true

echo
echo "Create DNS (or CoreDNS hosts entry) so that:"
echo "  $DEDICATED_HOST  →  same IP/LB as $API"
echo
echo "External DNS example:"
echo "  $DEDICATED_HOST.  IN  CNAME  $API."
echo "  # or A record to the ingress EXTERNAL-IP / hostname"
echo
echo "In-cluster CoreDNS workaround (no public DNS):"
echo "  kubectl -n kube-system edit cm coredns"
echo "  # under hosts { ... } add:"
echo "  #   <INGRESS_IP> $DEDICATED_HOST"
echo "  kubectl -n kube-system rollout restart deploy/coredns"
echo
echo "Then:"
echo "  ./ensure-dedicated-gateway-host.sh"
echo "  curl -sk https://$DEDICATED_HOST/idrepository/v1/identity/actuator/health"
