#!/bin/sh
# Copy configmaps from other namespaces

# Keycloak
kubectl -n config-server delete --ignore-not-found=true cm keycloak-host
kubectl --kubeconfig ~/.kube/iam_config -n keycloak get cm keycloak-host -o yaml | sed 's/namespace: keycloak/namespace: config-server/g' | kubectl -n config-server create -f -  

# Global
kubectl -n config-server delete --ignore-not-found=true cm global
kubectl -n default get cm global -o yaml | sed 's/namespace: default/namespace: config-server/g' | kubectl -n config-server create -f -  



