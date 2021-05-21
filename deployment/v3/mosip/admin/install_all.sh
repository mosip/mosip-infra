#!/bin/sh
# Installs the Admin module
# Make sure you have updated ui_values.yaml
helm repo update
kubectl create ns admin
echo Installing admin service. Will wait till service gets installed.
helm -n admin install admin-service mosip/admin-service --wait
echo 'Installing admin-ui'
helm -n admin install admin-ui mosip/admin-ui -f ui_values.yaml
