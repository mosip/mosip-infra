#!/bin/sh
# Uninstalls config server
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=config-server
while true; do
    read -p "Are you sure you want to delete config-server helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete config-server
        break
      else
        break
    fi
done
