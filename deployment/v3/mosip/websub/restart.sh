#!/bin/bash
# Restart the deployment
NS=websub
kubectl -n $NS rollout restart deploy
