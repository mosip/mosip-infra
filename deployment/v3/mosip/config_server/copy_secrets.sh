#!/bin/sh
# Postgres
kubectl -n config-server delete --ignore-not-found=true secret db-common-secrets 
kubectl -n postgres get secret db-common-secrets -o yaml | sed 's/namespace: postgres/namespace: config-server/g' | kubectl -n config-server create -f -  

# Keycloak
kubectl -n config-server delete --ignore-not-found=true secret keycloak
kubectl --kubeconfig ~/.kube/iam_config -n keycloak get secret keycloak -o yaml | sed 's/namespace: keycloak/namespace: config-server/g' | kubectl -n config-server create -f -  

kubectl -n config-server delete --ignore-not-found=true secret keycloak-client-secrets
kubectl --kubeconfig ~/.kube/iam_config -n keycloak get secret keycloak-client-secrets -o yaml | sed 's/namespace: keycloak/namespace: config-server/g' | kubectl -n config-server create -f -  

# Softhsm
kubectl -n config-server delete --ignore-not-found=true secret softhsm-kernel
kubectl -n softhsm get secret softhsm-kernel -o yaml | sed 's/namespace: softhsm/namespace: config-server/g' | kubectl -n config-server create -f -  

# If IDA has been installed
#kubectl -n softhsm get secret softhsm-ida -o yaml | sed 's/namespace: softhsm/namespace: config-server/g' | kubectl -n config-server create -f -  


