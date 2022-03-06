#!/bin/sh
# Restart the websub service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=websub
kubectl -n $NS rollout restart deploy
