#!/bin/bash

NS=regclient

function installing_regclient() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  echo Copying Resorces
  COPY_UTIL=$WORKDIR/utils/copy-cm-and-secrets/copy_cm_func.sh
  #Copy configmaps
  $COPY_UTIL configmap artifactory-share artifactory $NS
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_regclient   # calling function
