#!/bin/bash
# Uninstalls the info CronJob + dashboard
## Usage: ./delete.sh <environment> [kubeconfig]

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

function deleting_info_cronjob() {
  while true; do
      read -p "Are you sure you want to delete the info CronJob for $ENV_NAME?(Y/n) " yn
      if [ "$yn" = "Y" ]
        then
          kubectl delete -k "$DIR/overlays/$ENV_NAME" --ignore-not-found
          kubectl -n $NS delete configmap info-output --ignore-not-found
          break
        else
          break
      fi
  done
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
deleting_info_cronjob   # calling function
