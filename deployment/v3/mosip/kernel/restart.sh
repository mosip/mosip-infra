#!/bin/sh
# Restart the deployment
NS=kernel
kubectl -n $NS rollout restart deploy
