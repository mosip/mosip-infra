#!/bin/bash
# Uninstalls Regclient downloader
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

function deleting_regclient() {
  NS=regclient
  while true; do
      read -p "Are you sure you want to delete regclient helm chart?(Y/n) " yn
      if [ $yn = "Y" ]
        then
          helm -n $NS delete regclient
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
deleting_regclient   # calling function