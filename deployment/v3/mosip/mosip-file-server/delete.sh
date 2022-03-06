#!/bin/sh
# Uninstalls mosip-file-server
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosip-file-server
while true; do
    read -p "Are you sure you want to delete mosip-file-server helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete mosip-file-server
        break
      else
        break
    fi
done
