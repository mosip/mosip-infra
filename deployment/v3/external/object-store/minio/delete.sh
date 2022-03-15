#!/bin/sh
# Uninstalls Minio running inside the cluster 
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=minio
while true; do
    read -p "Are you sure you want to delete minio helm charts? Note: this will erase your object store data.(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete minio
        break
      else
        break
    fi
done
