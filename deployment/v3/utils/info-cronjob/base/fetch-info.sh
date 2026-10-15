#!/bin/sh
# Writes info.json (consumed by index.html) and info.txt (plain-text view) into $1.
# ENV_NAME labels the report; EXCLUDED_NAMESPACE is a regex of namespaces to leave out.
# Both are set at install time (see install.sh).
set -eu

OUT_DIR="${1:-/tmp/out}"
ENV_NAME="${ENV_NAME:-}"
EXCLUDED_NAMESPACE="${EXCLUDED_NAMESPACE:-^(istio|cattle|kube|info)}"

mkdir -p "$OUT_DIR"
kubectl get namespaces -o json > /tmp/namespaces.json
kubectl get deployments,statefulsets,daemonsets,cronjobs -A -o json > /tmp/workloads.json

jq -n --arg excl "$EXCLUDED_NAMESPACE" --arg now "$(date -u +%Y-%m-%dT%H:%M:%SZ)" --arg env "$ENV_NAME" \
  --slurpfile ns /tmp/namespaces.json --slurpfile w /tmp/workloads.json '
  def containers:
    if .kind == "CronJob" then .spec.jobTemplate.spec.template.spec.containers
    else .spec.template.spec.containers end;
  {
    environment: $env,
    generatedAt: $now,
    namespaces: [$ns[0].items[].metadata.name | select(test($excl) | not)],
    workloads: [
      $w[0].items[]
      | select(.metadata.namespace | test($excl) | not)
      | {
          namespace: .metadata.namespace,
          kind,
          name: .metadata.name,
          images: [containers[].image],
          desired: (if .kind == "CronJob" then null
                    elif .kind == "DaemonSet" then (.status.desiredNumberScheduled // 0)
                    else (.spec.replicas // 1) end),
          ready: (if .kind == "CronJob" then null
                  elif .kind == "DaemonSet" then (.status.numberReady // 0)
                  else (.status.readyReplicas // 0) end),
          schedule: .spec.schedule,
          suspend: (.spec.suspend // false),
          lastSchedule: .status.lastScheduleTime
        }
    ]
  }' > "$OUT_DIR/info.json"

jq -r '
  (.workloads | group_by(.namespace) | map({key: .[0].namespace, value: .}) | from_entries) as $by
  | (.namespaces[] as $ns
      | "Namespace: \($ns)", "----------------",
        (($by[$ns] // [])[] | "\(.kind): \(.name), Image: \(.images | join(", "))"),
        ""),
    "Script executed at \(.generatedAt)"' "$OUT_DIR/info.json" > "$OUT_DIR/info.txt"
