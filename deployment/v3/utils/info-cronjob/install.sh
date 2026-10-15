#!/bin/bash
# Installs the info CronJob + dashboard in any environment
## Usage: [SETTING=value ...] ./install.sh [kubeconfig]
##
## Settings (environment variables):
##   ENV_NAME            Name shown on the dashboard and written to info.json, e.g. collab.
##                       Prompted for when not set (default: current kube context name).
##   CLUSTER_NAME        Cluster name written to info.json (default: current kube context name, else ENV_NAME).
##   SCHEDULE            Cron schedule, in cluster time (default: "0 2 * * *").
##   GATEWAY             Istio gateway(s) serving /info, comma separated (default: istio-system/internal).
##                       The report lists every workload and image tag; only use istio-system/public deliberately.
##   KUBECTL_IMAGE       Collector image with kubectl, jq and sh (default: newest alpine/k8s release
##                       matching the cluster's Kubernetes minor version, looked up on Docker Hub).
##   EXCLUDED_NAMESPACE  Regex of namespaces left out of the report (default: ^(istio|cattle|kube|info)).
##   DRY_RUN=1           Print the rendered manifests instead of applying them.
##
## Example:
##   ENV_NAME=synergy SCHEDULE="30 3 * * *" ./install.sh ~/.kube/synergy.yaml

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=info
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_NAME=${ENV_NAME:-}
CLUSTER_NAME=${CLUSTER_NAME:-}
SCHEDULE=${SCHEDULE:-"0 2 * * *"}
GATEWAY=${GATEWAY:-istio-system/internal}
KUBECTL_IMAGE=${KUBECTL_IMAGE:-}
EXCLUDED_NAMESPACE=${EXCLUDED_NAMESPACE:-'^(istio|cattle|kube|info)'}
DRY_RUN=${DRY_RUN:-0}

# Renders a value as a single-quoted YAML scalar.
function yaml_quote() {
  local q="'"
  printf "'%s'" "${1//$q/$q$q}"
}

function read_settings() {
  if [ -z "$ENV_NAME" ]; then
    local default
    default=$(kubectl config current-context 2>/dev/null || true)
    read -p "Environment name shown on the dashboard [${default}]: " ENV_NAME
    ENV_NAME=${ENV_NAME:-$default}
  fi
  if ! [[ "$ENV_NAME" =~ ^[A-Za-z0-9._-]+$ ]]; then
    echo "ERROR: ENV_NAME '$ENV_NAME' must be non-empty and contain only letters, digits, '.', '_' or '-'; EXITING;"
    exit 1
  fi
  if [ -z "$CLUSTER_NAME" ]; then
    CLUSTER_NAME=$(kubectl config current-context 2>/dev/null || true)
    CLUSTER_NAME=${CLUSTER_NAME:-$ENV_NAME}
  fi
  if [ "$(echo "$SCHEDULE" | wc -w)" -ne 5 ]; then
    echo "ERROR: SCHEDULE '$SCHEDULE' is not a 5-field cron expression; EXITING;"
    exit 1
  fi
  if [ -z "$KUBECTL_IMAGE" ]; then
    detect_kubectl_image
  fi
}

# kubectl only supports a client within one minor version of the API server.
function detect_kubectl_image() {
  local minor tag
  minor=$(kubectl get --raw /version 2>/dev/null | grep -oE '"gitVersion": *"v[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+$' || true)
  if [ -n "$minor" ]; then
    tag=$(curl -fsS -m 20 "https://hub.docker.com/v2/repositories/alpine/k8s/tags?name=${minor}.&page_size=100" 2>/dev/null \
      | grep -oE "\"name\": *\"${minor//./\\.}\.[0-9]+\"" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -1 || true)
  fi
  if [ -z "${tag:-}" ]; then
    echo "ERROR: could not find an alpine/k8s image for Kubernetes ${minor:-<unknown>}; set KUBECTL_IMAGE; EXITING;"
    exit 1
  fi
  KUBECTL_IMAGE=alpine/k8s:$tag
}

# Writes a kustomize overlay for these settings on top of base/ into $1.
function render_overlay() {
  local out=$1 gw
  ln -s "$DIR/base" "$out/base"

  cat > "$out/kustomization.yaml" <<EOF
resources:
  - base
patches:
  - path: cronjob-patch.yaml
  - path: virtualservice-patch.yaml
EOF

  cat > "$out/cronjob-patch.yaml" <<EOF
apiVersion: batch/v1
kind: CronJob
metadata:
  name: info
  namespace: $NS
spec:
  schedule: $(yaml_quote "$SCHEDULE")
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: fetch-info
              image: $(yaml_quote "$KUBECTL_IMAGE")
              env:
                - name: ENV_NAME
                  value: $(yaml_quote "$ENV_NAME")
                - name: CLUSTER_NAME
                  value: $(yaml_quote "$CLUSTER_NAME")
                - name: EXCLUDED_NAMESPACE
                  value: $(yaml_quote "$EXCLUDED_NAMESPACE")
EOF

  {
    echo "apiVersion: networking.istio.io/v1beta1"
    echo "kind: VirtualService"
    echo "metadata:"
    echo "  name: info"
    echo "  namespace: $NS"
    echo "spec:"
    echo "  gateways:"
    IFS=',' read -ra gws <<< "$GATEWAY"
    for gw in "${gws[@]}"; do
      gw=$(echo "$gw" | xargs)
      if [ -n "$gw" ]; then
        echo "    - $(yaml_quote "$gw")"
      fi
    done
  } > "$out/virtualservice-patch.yaml"
}

function installing_info_cronjob() {
  read_settings

  OVERLAY=$(mktemp -d)
  trap 'rm -rf "$OVERLAY"' EXIT
  render_overlay "$OVERLAY"

  if [ "$DRY_RUN" = "1" ]; then
    kubectl kustomize "$OVERLAY"
    return 0
  fi

  echo "Installing info CronJob: env=$ENV_NAME cluster=$CLUSTER_NAME schedule='$SCHEDULE' gateway=$GATEWAY image=$KUBECTL_IMAGE exclude='$EXCLUDED_NAMESPACE'"

  echo Create $NS namespace
  kubectl create ns $NS --dry-run=client -o yaml | kubectl apply -f -

  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  if command -v helm >/dev/null && helm -n $NS status info >/dev/null 2>&1; then
    read -p "The old 'info' helm release exists in namespace $NS and must be removed first. Uninstall it? (Y/n) " yn
    if [ "$yn" != "Y" ]; then
      echo "Aborting; the helm release and this utility manage the same resources."
      exit 1
    fi
    helm -n $NS uninstall info
  fi

  # The collector may only update this ConfigMap, not create it. Create it before the nginx pod
  # mounts it, as some kubelets never pick up an optional ConfigMap that appears later.
  kubectl -n $NS get configmap info-output >/dev/null 2>&1 || kubectl -n $NS create configmap info-output

  kubectl apply -k "$OVERLAY"

  kubectl -n $NS rollout status deploy/info --timeout=300s \
    || echo "WARNING: rollout status timed out; check 'kubectl -n $NS get pods'"

  JOB=info-manual-$(date +%s)
  echo Running the collector once as job $JOB
  kubectl -n $NS create job --from=cronjob/info $JOB

  echo "Installed info CronJob. Report: https://<api host of $GATEWAY>/info (populated once job $JOB completes)"
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_info_cronjob   # calling function
