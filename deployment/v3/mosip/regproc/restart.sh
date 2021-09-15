#!/bin/bash
# Restart the deployment
NS=regproc
kubectl -n $NS rollout restart deploy
