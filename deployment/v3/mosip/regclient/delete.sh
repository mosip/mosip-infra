#!/bin/sh
# Uninstalls Regclient downloader
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=regclient
while true; do
    read -p "Are you sure you want to delete regclient helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete regclient
        break
      else
        break
    fi
done
