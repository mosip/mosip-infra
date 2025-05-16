#!/bin/bash
# wait-for-keygen.sh
until kubectl get job kernel-keygen -n keymanager -o jsonpath='{.status.succeeded}' | grep 1; do
  echo "Waiting for keygen job to complete..."
  sleep 10
done
