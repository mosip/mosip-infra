#!/bin/bash
# Patch notification alerts 

NS=cattle-monitoring-system

function installing_alerting() {

  # Define the Slack channel, Slack_api_url and Cluster name dynamically
  SLACK_CHANNEL="soil"
  SLACK_API_URL="https://hooks.slack.com/services/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"
  ENV_NAME="soil"

  ALERTMANAGER_FILE="../utils/alerting/alertmanager.yaml"
  PATCH_CLUSTER_NAME_FILE="../utils/alerting/patch-cluster-name.yaml"

  # Update the channel using sed
  sed -i "s|<YOUR-CHANNEL-HERE>|$SLACK_CHANNEL|g" "$ALERTMANAGER_FILE"
  sed -i "s|<YOUR-SLACK-API-URL>|$SLACK_API_URL|g" "$ALERTMANAGER_FILE"
  sed -i "s|<YOUR-CLUSTER-NAME-HERE>|$ENV_NAME|g" "$PATCH_CLUSTER_NAME_FILE"

  echo "Updated $ALERTMANAGER_FILE and $PATCH_CLUSTER_NAME_FILE"

  echo Patching alert manager secrets
  kubectl patch secret alertmanager-rancher-monitoring-alertmanager -n $NS  --patch="{\"data\": { \"alertmanager.yaml\": \"$(cat ../utils/alerting/alertmanager.yaml |base64 |tr -d '\n' )\" }}"
  echo Regenerating secrets
  kubectl delete secret alertmanager-rancher-monitoring-alertmanager-generated -n $NS
  echo Adding cluster name
  kubectl patch Prometheus rancher-monitoring-prometheus -n $NS --patch-file ../utils/alerting/patch-cluster-name.yaml --type=merge
  echo Applying custom alerts
  kubectl apply -f ../utils/alerting/custom-alerts/
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_alerting   # calling function
