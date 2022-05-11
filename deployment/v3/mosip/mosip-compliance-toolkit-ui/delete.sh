#!/bin/sh
# Uninstalls mosip-compliance-toolkit-ui helm charts
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=admin
while true; do
    read -p "Are you sure you want to delete ALL Admin helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete mosip-compliance-toolkit-ui
	kubectl delete -n $NS -f mosip-compliance-toolkit-ui
        break
      else
        break
    fi
done