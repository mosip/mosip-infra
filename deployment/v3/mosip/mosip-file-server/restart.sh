#!/bin/sh
# Restart the mosip-file service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosip-file-server
kubectl -n $NS rollout restart deploy
