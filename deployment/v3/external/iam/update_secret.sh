#!/bin/sh
# If you update admin password via console, call this script to update the secret in kubernetes.
# Usage:
# ./update_secrets.sh <new_admin_password>
kubectl -n keycloak create secret generic keycloak --from-literal=admin-password=$1 --dry-run=client -o yaml | kubectl -n keycloak  apply -f -
