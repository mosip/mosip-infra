#!/bin/sh
# Restart the deployment
# CAUTION: Restart will restart softhms as well.  Although, that is not expected to create any problems.
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=ida
kubectl -n $NS rollout restart deploy
