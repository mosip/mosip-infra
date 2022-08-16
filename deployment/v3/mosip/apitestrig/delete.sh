#!/bin/sh
# Uninstalls apitestrig
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=apitestrig
while true; do
    read -p "Are you sure you want to delete apitestrig helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        kubectl -n $NS delete configmap db-cm global keycloak-host s3 apitestrig
        kubectl -n $NS delete secret db-secrets keycloak-client-secrets s3
        helm -n $NS delete apitestrig
        break
      else
        break
    fi
done
