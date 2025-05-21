#!/bin/bash
# Copy configmaps from other namespaces
NS=packetcreator

function packetcreator() {
    echo Istio label
    kubectl label ns $NS istio-injection=disabled --overwrite

    api_internal_host=$( kubectl -n default get cm global -o json | jq -rc '.data."mosip-api-internal-host"' )
    kubectl -n $NS create cm global --from-literal="mosip-api-internal-host"="$api_internal_host"

    return 0
}
# Set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
packetcreator   # calling function
