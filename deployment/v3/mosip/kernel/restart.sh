#!/bin/sh
# Restart the kernel services

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kernel
kubectl -n $NS rollout restart deploy

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Retarted kernel services
