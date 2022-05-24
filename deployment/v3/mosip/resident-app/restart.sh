#!/bin/sh
# Restart the resident-app service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=resident
kubectl -n $NS rollout restart deploy/resident-app

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Retarted resident-app services
