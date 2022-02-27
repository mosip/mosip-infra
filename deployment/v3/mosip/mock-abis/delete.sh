#!/bin/sh
# Uninstalls Mock ABIS
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=abis
while true; do
    read -p "Are you sure you want to delete mock-abis helm chart? Y/n ?" yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete mock-abis
        break
      else
        break
    fi
done
