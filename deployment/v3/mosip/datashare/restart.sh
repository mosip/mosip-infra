#!/bin/sh
# Restart the datashare service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=datashare
kubectl -n $NS rollout restart deploy
