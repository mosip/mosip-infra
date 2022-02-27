#!/bin/sh
# Uninstalls all Admin helm charts 
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=admin
while true; do
    read -p "Are you sure you want to delete admin helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete admin-ui
        helm -n $NS delete admin-service
        break
      else
        break
    fi
done
