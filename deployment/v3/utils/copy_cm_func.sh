#!/bin/sh
# Copy configmap and secret from one namespace to another
# ./copy_cm_func.sh <resource> <configmap_name> <source_namespace> <destination_namespace> [source_cluster_config]
# Parameters:
#   resource: configmap|secret
#   source_cluster_config (optional): only needed while copying resources from other clusters. Example: `~/.kube/keycloak_config`

if [ $1 = "configmap" ]
then
  RESOURCE=configmap
elif [ $1 = "secret" ]
then
  RESOURCE=secret
else
  echo "Incorrect resource $1. Exiting.."
  exit 1
fi

if [ $# -ge 5 ]
then
  KC_SOURCE="kubectl --kubeconfig $5"
else
  KC_SOURCE=kubectl
fi
kubectl -n $4 delete --ignore-not-found=true $RESOURCE $2
$KC_SOURCE -n $3 get $RESOURCE $2 -o yaml | sed "s/namespace: $3/namespace: $4/g" | kubectl -n $4 create -f -  






