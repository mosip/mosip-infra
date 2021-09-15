#!/bin/bash
# Restart the deployment
NS=idrepo
kubectl -n $NS rollout restart deploy
