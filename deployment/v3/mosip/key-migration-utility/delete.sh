#!/bin/bash
# Uninstalls key-migration-utility
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 2 ] ; then
  export KUBECONFIG=$2
fi

function deleting_hsm_key_migrator() {
  NS=key-migration-utility
  module=$1
  while true; do
      read -p "Are you sure you want to delete key-migration-utility helm chart?(Y/n) " yn
      if [ $yn = "Y" ]
        then
          helm -n $NS list
          helm -n $NS delete "key-migration-utility-$module"
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
if [[ $# -lt 1 ]]; then
  echo "SoftHsm module name not passed; EXITING;"
  exit 0;
fi
deleting_hsm_key_migrator $1   # calling function
