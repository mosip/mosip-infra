#!/bin/sh
# Restart the mosip-compliance-toolkit-ui services
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=compliance-toolkit

kubectl -n $NS rollout restart deploy

kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

echo Retarted compliance-toolkit and compliance-toolkit-ui services
