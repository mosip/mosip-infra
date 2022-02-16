#!/bin/sh
## Installs prerequisites for LongHorn. 
NS=longhorn-system

echo Create namespace
kubectl create namespace $NS

echo Installing iscsi
kubectl apply -n $NS -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.1/deploy/prerequisite/longhorn-iscsi-installation.yaml

echo Installing nfsv4 client
 kubectl apply -n $NS -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.1/deploy/prerequisite/longhorn-nfs-installation.yaml
