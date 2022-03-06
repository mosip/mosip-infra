#!/bin/sh
# Uninstalls Websub
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=websub
while true; do
    read -p "Are you sure you want to delete Websub helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete websub
        helm -n $NS delete websub-consolidator
        break
      else
        break
    fi
done
