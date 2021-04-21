#!/bin/sh
# Copy configmap from one namespace to another
# "cluster config path" is only needed while copying CMs from other clusters. Example: `~/.kube/keycloak_config`
# ./copy_cm_func.sh <configmap name> <source namespace> <destination namespace> [source cluster config]
if [ ! -z $4 ]
then
  KC_SOURCE="kubectl --kubeconfig $4"
else
  KC_SOURCE=kubectl
fi
kubectl -n $3 delete --ignore-not-found=true cm $1
$KC_SOURCE -n $2 get cm $1 -o yaml | sed "s/namespace: $2/namespace: $3/g" | kubectl -n $3 create -f -  





