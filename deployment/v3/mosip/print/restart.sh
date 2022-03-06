#!/bin/sh
# Restart the print services
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=print
kubectl -n $NS rollout restart deploy
