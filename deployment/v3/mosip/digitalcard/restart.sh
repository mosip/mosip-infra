#!/bin/sh
# Restart the digitalcard
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=digitalcard
kubectl -n $NS rollout restart deploy

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Restarted digitalcard services
