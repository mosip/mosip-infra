#!/bin/sh
# Restart the pms services
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=pms
kubectl -n $NS rollout restart deploy
