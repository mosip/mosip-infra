#!/bin/bash
# Copy secrets from other namespaces
# DST_NS: Destination namespace
COPY_UTIL=../../utils/copy_cm_func.sh
DST_NS=postgres
SECRET_REGEX='db-.*-secret'
secrets_list=$(kubectl get secrets -n db-password --no-headers -o custom-columns=':.metadata.name' | grep "$SECRET_REGEX")
for secret in $secrets_list; do
  $COPY_UTIL secret $secret db-password $DST_NS
done