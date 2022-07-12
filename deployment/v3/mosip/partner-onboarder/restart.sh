#!/bin/sh
# Restart partner onboarder. This will rerun the onboarding scripts.

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=onboarder
kubectl -n $NS rollout restart deploy

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Reran partner onboarder
