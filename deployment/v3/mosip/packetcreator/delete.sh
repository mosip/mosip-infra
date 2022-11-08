#!/bin/sh
# Uninstalls packetcreator
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=packetcreator
while true; do
    read -p "Are you sure you want to delete packetcreator helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete packetcreator
        break
      else
        break
    fi
done
