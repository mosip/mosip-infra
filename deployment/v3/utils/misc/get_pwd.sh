#!/bin/sh
# Example script to fetch a password from a secret.
# Usage: sh get_pwd.sh [kubeconfig file] 
# Default kubeconfig file is $HOME/.kube/config

if [ $# -ge 1 ]
  then
    export KUBECONFIG=$1
fi

echo Password of mymodule: $(kubectl get secret --namespace <ns> <secret name> -o jsonpath="{.data.<secret key>}" | base64 --decode)
