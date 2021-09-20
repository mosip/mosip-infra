#!/bin/sh
# Get postgres password
# Usage: sh get_pwd.sh [kubeconfig file] 
# Default kubeconfig file is $HOME/.kube/config
if [ $# -ge 1 ]
  then
    export KUBECONFIG=$1
fi

echo postgres: $(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)
echo db-user: $(kubectl get secret --namespace postgres db-common-secrets -o jsonpath="{.data.db-dbuser-password}" | base64 --decode)
