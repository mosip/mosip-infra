#!/bin/sh
# Restart the deployment
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=admin
kubectl -n $NS rollout restart deploy 
