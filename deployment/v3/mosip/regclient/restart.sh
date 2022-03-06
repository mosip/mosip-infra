#!/bin/sh
# Restart the regclient service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=regclient
kubectl -n $NS rollout restart deploy
