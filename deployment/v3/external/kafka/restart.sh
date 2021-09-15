#!/bin/bash
# Restart the deployment
NS=kafka
kubectl -n $NS rollout restart statefulset
