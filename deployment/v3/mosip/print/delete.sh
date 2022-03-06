#!/bin/sh
# Uninstalls print service
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=print
while true; do
    read -p "Are you sure you want to delete print helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete print-service
        break
      else
        break
    fi
done
