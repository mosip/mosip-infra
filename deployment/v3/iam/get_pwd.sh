#!/bin/sh
# Get admin password
echo Password: $(kubectl get secret --namespace default keycloak -o jsonpath="{.data.admin-password}" | base64 --decode)
