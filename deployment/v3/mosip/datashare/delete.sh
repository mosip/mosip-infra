#!/bin/sh
# Uninstalls datashare
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=datashare
while true; do
    read -p "Are you sure you want to delete datashare helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete datashare
        break
      else
        break
    fi
done
