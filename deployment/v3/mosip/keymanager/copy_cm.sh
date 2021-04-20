#!/bin/sh
# Copy configmaps from other namespaces

# Artifactory
kubectl -n keymanager delete --ignore-not-found=true cm artifactory-share
kubectl -n artifactory get cm artifactory-share -o yaml | sed 's/namespace: artifactory/namespace: keymanager/g' | kubectl -n keymanager create -f -  

# Softhsm
kubectl -n keymanager delete --ignore-not-found=true cm softhsm-kernel-share
kubectl -n softhsm get cm softhsm-kernel-share -o yaml | sed 's/namespace: softhsm/namespace: keymanager/g' | kubectl -n keymanager create -f -  

# Config server
kubectl -n keymanager delete --ignore-not-found=true cm config-server-share
kubectl -n config-server get cm config-server-share -o yaml | sed 's/namespace: config-server/namespace: keymanager/g' | kubectl -n keymanager create -f -  




