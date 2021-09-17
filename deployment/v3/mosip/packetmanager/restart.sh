#!/bin/sh
# Restart the deployment
NS=packetmanager
kubectl -n $NS rollout restart deploy
