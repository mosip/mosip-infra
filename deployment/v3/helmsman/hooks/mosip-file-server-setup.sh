#!/bin/bash
NS=mosip-file-server

function installing_mfs() {

  kubectl -n $NS --ignore-not-found=true delete configmap mosip-file-server
  kubectl -n $NS --ignore-not-found=true delete secret keycloak-client-secret

  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_mfs   # calling function
