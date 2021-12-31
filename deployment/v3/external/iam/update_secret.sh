#!/bin/sh
# If you update admin password via console, call this script to update the secret in kubernetes.
# Usage:
# ./update_secrets.sh <new_admin_password> [kube_config_file]

if [ $# -ge 2 ]; then
  CLUSTER_CONFIG=$2
else
  CLUSTER_CONFIG=$HOME/.kube/iam_config
fi
alias KK='kubectl --kubeconfig $CLUSTER_CONFIG -n keycloak'
$KK create secret generic keycloak --from-literal=admin-password=$1 --dry-run=client -o yaml | $KK  apply -f -
