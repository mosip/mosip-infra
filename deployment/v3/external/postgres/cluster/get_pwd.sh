#!/bin/sh
# Get postgres password
echo Password: $(kubectl get secret --namespace default postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
