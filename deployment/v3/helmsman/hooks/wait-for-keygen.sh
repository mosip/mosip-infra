#!/bin/bash
# wait-for-keygen.sh
until kubectl get job kernel-keygen -n keymanager -o jsonpath='{.status.succeeded}' | grep 1; do
  echo "Waiting for keygen job to complete..."
  sleep 120
done
kubectl label ns keymanager istio-injection=enabled --overwrite