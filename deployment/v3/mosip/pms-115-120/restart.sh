#!/bin/sh
# Restart the pms-115-120 services
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=pms-115-120
kubectl -n $NS rollout restart deploy

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Restarted pms-115-120 service
