#!/bin/sh
# Restart the resident service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=resident
kubectl -n $NS rollout restart deploy
