#!/bin/sh
# Restart the artifactory service
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=artifactory
kubectl -n $NS rollout restart deploy
