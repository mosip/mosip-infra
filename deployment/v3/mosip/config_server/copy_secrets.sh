#!/bin/sh
kubectl -n postgres get secret db-common-secrets -o yaml | sed 's/namespace: postgres/namespace: config-server/g' | kubectl -n config-server create -f -  
kubectl -n keycloak get secret keycloak-client-secrets -o yaml | sed 's/namespace: keycloak/namespace: config-server/g' | kubectl -n config-server create -f -  
kubectl -n keycloak get secret keycloak -o yaml | sed 's/namespace: keycloak/namespace: config-server/g' | kubectl -n config-server create -f -  


