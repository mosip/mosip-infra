#!/bin/bash
# wait-for-keygen.sh
until kubectl get job ida-keygen -n ida -o jsonpath='{.status.succeeded}' | grep 1; do
  echo "Waiting for keygen job to complete..."
  sleep 120
done
kubectl label ns ida istio-injection=enabled --overwrite
