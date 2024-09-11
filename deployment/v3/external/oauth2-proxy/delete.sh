#!/bin/bash

NS=oauth2-proxy

if [ $# -ge 1 ]; then
  export KUBECONFIG=$1
fi

function Deleting_oauth2_proxy() {
  kubectl delete -n $NS -f oauth2-proxy.yaml
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
Deleting_oauth2_proxy_oauth2_proxy   # calling function
}