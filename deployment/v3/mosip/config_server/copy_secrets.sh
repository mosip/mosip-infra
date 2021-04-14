#!/bin/sh
# Postgres
kubectl -n postgres get secret db-common-secrets -o yaml | sed 's/namespace: postgres/namespace: config-server/g' | kubectl -n config-server create -f -  

# Keycloak
kubectl --kubeconfig ~/.kube/iam_config -n keycloak get secret keycloak -o yaml | sed 's/namespace: keycloak/namespace: config-server/g' | kubectl -n config-server apply -f -  
kubectl --kubeconfig ~/.kube/iam_config -n keycloak get secret keycloak-client-secrets -o yaml | sed 's/namespace: keycloak/namespace: config-server/g' | kubectl -n config-server apply -f -  

# Softhsm
kubectl -n softhsm get secret softhsm-kernel -o yaml | sed 's/namespace: softhsm/namespace: config-server/g' | kubectl -n config-server create -f -  
# If IDA has been installed
kubectl -n softhsm get secret softhsm-ida -o yaml | sed 's/namespace: softhsm/namespace: config-server/g' | kubectl -n config-server create -f -  


