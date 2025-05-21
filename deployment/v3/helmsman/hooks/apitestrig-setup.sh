#!/bin/bash
# Copy configmaps from other namespaces
NS=apitestrig

function copy_resource() {
    echo Istio label
    kubectl label ns $NS istio-injection=disabled --overwrite
    
    echo "Delete s3, db, & apitestrig configmap if exists"
    kubectl -n $NS delete --ignore-not-found=true configmap s3
    kubectl -n $NS delete --ignore-not-found=true configmap db
    kubectl -n $NS delete --ignore-not-found=true configmap apitestrig

    echo Copying Resorces
    COPY_UTIL=$WORKDIR/utils/copy-cm-and-secrets/copy_cm_func.sh
    #Copy configmaps
    $COPY_UTIL configmap global default $NS
    $COPY_UTIL configmap keycloak-host keycloak $NS
    $COPY_UTIL configmap artifactory-share artifactory $NS
    $COPY_UTIL configmap config-server-share config-server $NS
    #Copy Secrets
    $COPY_UTIL secret keycloak-client-secrets keycloak $NS
    $COPY_UTIL secret s3 s3 $NS
    $COPY_UTIL secret postgres-postgresql postgres $NS
    return 0
}
# Set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialized variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
copy_resource   # calling function