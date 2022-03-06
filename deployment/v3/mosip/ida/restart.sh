#!/bin/sh
# Restart the ida services
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=ida
kubectl -n $NS rollout restart deploy
