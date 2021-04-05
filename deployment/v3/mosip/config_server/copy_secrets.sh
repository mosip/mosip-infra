#!/bin/sh
kubectl -n postgres get secret db-common-secrets -o yaml | sed 's/namespace: postgres/namespace: config-server/g' | kubectl -n config-server create -f -  


