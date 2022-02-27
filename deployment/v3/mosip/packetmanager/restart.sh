#!/bin/sh
# Restart the deployment
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=packetmanager
kubectl -n $NS rollout restart deploy
