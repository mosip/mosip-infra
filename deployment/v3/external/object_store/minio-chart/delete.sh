#!/bin/sh
# Uninstalls Keycloak
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi
NS=minio
while true; do
    read -p "Are you sure you want to delete Minio? This is DANGEROUS! (Y/n) " yn
    if [ $yn = "Y" ]
      then
        kubectl delete ns $NS
        break
      else
        break
    fi
done
