#!/bin/sh
## Installs prerequisites for LongHorn. 
NS=longhorn-system

echo Create $NS namespace
kubectl create namespace $NS

echo Installing iscsi
kubectl apply -n $NS -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.3/deploy/prerequisite/longhorn-iscsi-installation.yaml

echo Installing nfsv4 client
kubectl apply -n $NS -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.3/deploy/prerequisite/longhorn-nfs-installation.yaml

echo Pre-requisites for longhorn are installed
