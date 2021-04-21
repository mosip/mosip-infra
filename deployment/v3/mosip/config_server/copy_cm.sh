#!/bin/sh
# Copy configmaps from other namespaces
# DST_NS: Destination namespace 
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=config-server

$COPY_UTIL global default $DST_NS 
$COPY_UTIL keycloak-host keycloak $DST_NS ~/.kube/iam_config

## Keycloak
#kubectl -n config-server delete --ignore-not-found=true cm keycloak-host
#kubectl --kubeconfig ~/.kube/iam_config -n keycloak get cm keycloak-host -o yaml | sed 's/namespace: keycloak/namespace: config-server/g' | kubectl -n config-server create -f -  




