#!/bin/bash
# Get s3 credentials
echo s3 access-key: $(kubectl get cm  --namespace s3 s3 -o jsonpath="{.data.s3-user-key}")
echo s3 secret: $(kubectl get secret --namespace s3 s3 -o jsonpath="{.data.s3-user-secret}" | base64 --decode)
