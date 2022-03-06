#!/bin/sh
# Restart the packetmanager services
## Usage: ./restart.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi


NS=packetmanager
kubectl -n $NS rollout restart deploy
