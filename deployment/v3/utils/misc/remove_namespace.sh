#!/bin/sh
# Script to force remove a namespace.
# Usage: ./remove_namespace <namespace>
set -eou pipefail
namespace=$1
if [ -z "$namespace" ]
then
  echo "This script requires a namespace argument input. None found. Exiting."
  exit 1
fi
kubectl get namespace $namespace -o json | jq '.spec = {"finalizers":[]}' > rknf_tmp.json
kubectl delete ns $namespace
kubectl replace --raw "/api/v1/namespaces/$namespace/finalize" -f rknf_tmp.json
rm rknf_tmp.json
