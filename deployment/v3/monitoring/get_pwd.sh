#!/bin/sh
# Get admin password
echo Grafana admin user: $(kubectl get secret --namespace cattle-monitoring-system rancher-monitoring-grafana -o jsonpath="{.data.admin-user}" | base64 --decode)
echo Grafana admin password: $(kubectl get secret --namespace cattle-monitoring-system rancher-monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
