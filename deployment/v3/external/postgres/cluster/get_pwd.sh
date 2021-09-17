#!/bin/sh
# Get postgres password
echo postgres: $(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
echo db-user: $(kubectl get secret --namespace postgres db-common-secrets -o jsonpath="{.data.db-dbuser-password}" | base64 --decode)
