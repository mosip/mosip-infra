#!/bin/sh
# Get admin password
echo Password: $(kubectl get secret --namespace config-server config-server -o jsonpath="{.data.encrypt-key}" | base64 --decode)
