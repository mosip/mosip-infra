#!/bin/sh
# Restart the mosip-file service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=mosip-file-server
kubectl -n $NS rollout restart deploy

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Retarted mosip-file-service
