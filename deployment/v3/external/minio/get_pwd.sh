#!/bin/sh
# Get admin password
echo access-key: $(kubectl get secret --namespace minio minio -o jsonpath="{.data.access-key}" | base64 --decode)
echo secret-key: $(kubectl get secret --namespace minio minio -o jsonpath="{.data.secret-key}" | base64 --decode)
