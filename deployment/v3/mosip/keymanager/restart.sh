#!/bin/sh
# Restart the keymanager
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=keymanager
kubectl -n $NS rollout restart deploy keymanager
