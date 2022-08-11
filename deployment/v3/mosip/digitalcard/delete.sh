#!/bin/sh
# Uninstalls digital-card-service
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=digitalcard
while true; do
    read -p "Are you sure you want to delete digital-card-service helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete digitalcard
        break
      else
        break
    fi
done
