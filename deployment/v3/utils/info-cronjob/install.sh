#!/bin/bash
# Installs the info CronJob + dashboard for an environment
## Usage: ./install.sh <environment> [kubeconfig]
## Environments: the directories under overlays/ (e.g. collab, released)

if [ $# -lt 1 ] ; then
  echo "Usage: $0 <environment> [kubeconfig]"
  exit 1
fi

ENV_NAME=$1
if [ $# -ge 2 ] ; then
  export KUBECONFIG=$2
fi

NS=info
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OVERLAY="$DIR/overlays/$ENV_NAME"

function installing_info_cronjob() {
  if [ ! -d "$OVERLAY" ]; then
    echo "ERROR: No overlay for '$ENV_NAME'. Available: $(ls "$DIR/overlays" | tr '\n' ' ')"
    exit 1
  fi

  echo Create $NS namespace
  kubectl create ns $NS --dry-run=client -o yaml | kubectl apply -f -

  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  if helm -n $NS status info >/dev/null 2>&1; then
    read -p "The old 'info' helm release exists in namespace $NS and must be removed first. Uninstall it? (Y/n) " yn
    if [ "$yn" != "Y" ]; then
      echo "Aborting; the helm release and this utility manage the same resources."
      exit 1
    fi
    helm -n $NS uninstall info
  fi

  echo Installing info CronJob for $ENV_NAME
  kubectl apply -k "$OVERLAY"

  kubectl -n $NS rollout status deploy/info --timeout=300s \
    || echo "WARNING: rollout status timed out; check 'kubectl -n $NS get pods'"

  JOB=info-manual-$(date +%s)
  echo Running the collector once as job $JOB
  kubectl -n $NS create job --from=cronjob/info $JOB

  echo "Installed info CronJob. Report: https://<public-api-host>/info (populated once job $JOB completes)"
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_info_cronjob   # calling function
