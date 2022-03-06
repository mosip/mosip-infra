#!/bin/sh
# Restart the config-server service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=config-server
kubectl -n $NS rollout restart deploy
