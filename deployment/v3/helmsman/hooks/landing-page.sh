#!/bin/bash

NS=landing-page

function landing_page_setup() {
  echo Istio label
  kubectl label ns $NS istio-injection=enabled --overwrite

  kubectl get configmap global -n default -o yaml \
  | sed 's/namespace: default/namespace: landing-page/' \
  | kubectl apply -f -

  return 0
}
# Set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
landing_page_setup   # calling function
