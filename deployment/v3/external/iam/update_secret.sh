#!/bin/sh
# If you update admin password via console, call this script to update the secret in kubernetes.
# Usage:
# ./update_secrets.sh <new_admin_password>
CLUSTER_CONFIG=$HOME/.kube/iam_config
alias KK='kubectl --kubeconfig $CLUSTER_CONFIG -n keycloak'
$KK create secret generic keycloak --from-literal=admin-password=$1 --dry-run=client -o yaml | $KK  apply -f -
