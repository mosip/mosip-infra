#!/bin/sh
# Restart the deployment
NS=config-server
kubectl -n $NS rollout restart deploy
