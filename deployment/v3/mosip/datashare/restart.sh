#!/bin/sh
# Restart the deployment
NS=datashare
kubectl -n $NS rollout restart deploy
