#!/bin/bash
# Uninstalls all kernel helm charts 
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


function deleting_kernel() {
  NS=kernel
  while true; do
      read -p "Are you sure you want to delete all kernel helm charts?(Y/n) " yn
      if [ $yn = "Y" ]
        then
          helm -n $NS delete auditmanager
          helm -n $NS delete authmanager
          helm -n $NS delete idgenerator
          helm -n $NS delete masterdata
          helm -n $NS delete otpmanager
          helm -n $NS delete pridgenerator
          helm -n $NS delete ridgenerator
          helm -n $NS delete syncdata
          helm -n $NS delete notifier
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
deleting_kernel   # calling function