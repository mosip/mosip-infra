#!/bin/sh
# Restart the deployment
NS=resident
kubectl -n $NS rollout restart deploy
