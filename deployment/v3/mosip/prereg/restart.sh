#!/bin/sh
# Restart the prereg services
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=prereg
kubectl -n $NS rollout restart deploy
