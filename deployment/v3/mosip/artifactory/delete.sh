#!/bin/sh
# Uninstalls artifactory
# Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=artifactory
while true; do
    read -p "Are you sure you want to delete artifactory helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete artifactory
        break
      else
        break
    fi
done
