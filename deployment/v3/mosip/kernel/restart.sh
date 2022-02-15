#!/bin/sh
# Restart the deployment
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kernel
kubectl -n $NS rollout restart deploy
