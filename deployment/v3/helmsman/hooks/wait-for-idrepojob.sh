#!/bin/bash
# wait-for-keygen.sh
until kubectl get job idrepo-saltgen -n idrepo -o jsonpath='{.status.succeeded}' | grep 1; do
  echo "Waiting for keygen job to complete..."
  sleep 120
done
kubectl label ns idrepo istio-injection=enabled --overwrite
