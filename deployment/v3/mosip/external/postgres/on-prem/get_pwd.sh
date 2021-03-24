#!/bin/sh
kubectl get secret postgres-postgresql -o template --template='{{index .data "postgresql-password" | base64decode }}'
