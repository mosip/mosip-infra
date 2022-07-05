#!/bin/sh
# Uninstalls Keycloak
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi
NS=keycloak
while true; do
    read -p "Are you sure you want to delete Keyclaok? This is DANGEROUS! (Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete keycloak
        helm -n $NS delete keycloak-init
        helm -n $NS delete istio-addons
        break
      else
        break
    fi
done
