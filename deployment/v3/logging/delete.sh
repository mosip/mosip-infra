#!/bin/sh
# Uninstalls all logging helm charts
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi
NS=cattle-logging-system
while true; do
    read -p "Are you sure you want to delete ALL logging helm charts from $KUBECONFIG cluster?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete elasticsearch
        break
      else
        break
    fi
done
