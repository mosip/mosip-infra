#!/bin/sh
# Uninstalls all admin helm charts 
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=admin
while true; do
    read -p "Are you sure you want to delete ALL Admin helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete admin-ui
        helm -n $NS delete admin-service
        helm -n $NS delete admin-hotlist
	kubectl delete -n $NS -f admin-proxy.yaml
        break
      else
        break
    fi
done
