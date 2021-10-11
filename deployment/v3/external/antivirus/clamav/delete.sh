#!/bin/sh
# Uninstalls Clamav
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=clamav
while true; do
    read -p "Are you sure you want to delete Clamav helm chart?(Y/n) " yn
    if [ $yn == "Y" ]
      then
        helm -n $NS delete clamav
        break
      else
        break
    fi
done
