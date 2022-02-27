#!/bin/sh
# Uninstalls all PMS helm charts
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pms
while true; do
    read -p "Are you sure you want to delete pms helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete pms-partner
        helm -n $NS delete pms-policy
        break
      else
        break
    fi
done
