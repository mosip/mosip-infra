#!/bin/bash
# One-time: patch Gateway to accept dedicated idrepo1230 host.
# Usage: DEDICATED_HOST=api-idrepo1230.qa11new.mosip.net ./ensure-dedicated-gateway-host.sh

if [ $# -ge 1 ]; then export KUBECONFIG=$1; fi
DEDICATED_HOST=${DEDICATED_HOST:-api-idrepo1230.qa11new.mosip.net}
GW_NS=${GW_NS:-istio-system}
GW_NAME=${GW_NAME:-internal}

set -euo pipefail

echo "Checking Gateway $GW_NS/$GW_NAME for host $DEDICATED_HOST"
kubectl -n "$GW_NS" get gateway "$GW_NAME" -o yaml > /tmp/gw-backup.yaml
HOSTS=$(kubectl -n "$GW_NS" get gateway "$GW_NAME" -o jsonpath='{range .spec.servers[*].hosts[*]}{.}{"\n"}{end}')
echo "Current hosts:"
echo "$HOSTS"

if echo "$HOSTS" | grep -qx "$DEDICATED_HOST"; then
  echo "Host already present."
  exit 0
fi

export DEDICATED_HOST
# Add host to every https/http server that already has api-internal (typical MOSIP gateway)
python3 - <<'PY'
import json, subprocess, os
host = os.environ["DEDICATED_HOST"]
gw_ns = os.environ.get("GW_NS", "istio-system")
gw_name = os.environ.get("GW_NAME", "internal")
raw = subprocess.check_output(["kubectl", "-n", gw_ns, "get", "gateway", gw_name, "-o", "json"])
gw = json.loads(raw)
changed = False
for server in gw.get("spec", {}).get("servers", []):
    hosts = server.setdefault("hosts", [])
    if any(h.startswith("api-internal.") or h == "*" for h in hosts):
        if host not in hosts:
            hosts.append(host)
            changed = True
if not changed and gw.get("spec", {}).get("servers"):
    hosts = gw["spec"]["servers"][0].setdefault("hosts", [])
    if host not in hosts:
        hosts.append(host)
        changed = True
if not changed:
    raise SystemExit("No change made")
subprocess.run(["kubectl", "apply", "-f", "-"], input=json.dumps(gw).encode(), check=True)
print("Added", host, "to Gateway", f"{gw_ns}/{gw_name}")
PY

echo
echo "Smoke (needs DNS):"
echo "  curl -sk https://$DEDICATED_HOST/idrepository/v1/identity/actuator/health"
echo "Backup: /tmp/gw-backup.yaml"
