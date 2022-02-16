#!/bin/sh
# Restart the deployment
NS=websub
kubectl -n $NS rollout restart deploy
