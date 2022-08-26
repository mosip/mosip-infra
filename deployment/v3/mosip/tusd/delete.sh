#!/bin/sh
# Uninstalls tusd service
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=tusd
while true; do
    read -p "Are you sure you want to delete tusd helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete tusd-service
        break
      else
        break
    fi
done
