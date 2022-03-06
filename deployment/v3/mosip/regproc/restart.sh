#!/bin/sh
# Restart the regproc services
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=regproc
kubectl -n $NS rollout restart deploy
