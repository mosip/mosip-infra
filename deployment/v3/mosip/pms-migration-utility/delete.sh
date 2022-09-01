#!/bin/sh
# Uninstalls all pms helm charts
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=upgrade
while true; do
    read -p "Are you sure you want to delete all pms helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete pms-migration-utility
        break
      else
        break
    fi
done
