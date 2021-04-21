#!/bin/sh
# Get postgres password
echo postgres: $(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
echo app-admin: $(kubectl get secret --namespace postgres db-common-secrets -o jsonpath="{.data.db-appadmin-password}" | base64 --decode)
echo db-admin: $(kubectl get secret --namespace postgres db-common-secrets -o jsonpath="{.data.db-dbadmin-password}" | base64 --decode)
echo db-user: $(kubectl get secret --namespace postgres db-common-secrets -o jsonpath="{.data.db-dbuser-password}" | base64 --decode)
echo sysadmin-user: $(kubectl get secret --namespace postgres db-common-secrets -o jsonpath="{.data.db-sysadmin-password}" | base64 --decode)
