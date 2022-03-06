#!/bin/sh
# Restarts the mock ABIS
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=abis
kubectl -n $NS rollout restart deploy 
