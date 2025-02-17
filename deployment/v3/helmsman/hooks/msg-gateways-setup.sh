#!/bin/bash
# Creates configmap and secrets for SMTP and SMS

NS=msg-gateways

function msg_gateway() {

  SMTP_HOST=mock-smtp.mock-smtp
  SMS_HOST=mock-smtp.mock-smtp
  SMTP_PORT=8025
  SMS_PORT=8080
  SMTP_USER=
  SMS_USER=
  SMTP_SECRET="''"
  SMS_SECRET="''"
  SMS_AUTHKEY="authkey"

  kubectl -n $NS create configmap msg-gateway --from-literal="smtp-host=$SMTP_HOST" --from-literal="sms-host=$SMS_HOST" --from-literal="smtp-port=$SMTP_PORT" --from-literal="sms-port=$SMS_PORT" --from-literal="smtp-username=$SMTP_USER" --from-literal="sms-username=$SMS_USER"
  kubectl -n $NS create secret generic msg-gateway --from-literal="smtp-secret=$SMTP_SECRET" --from-literal="sms-secret=$SMS_SECRET" --from-literal="sms-authkey=$SMS_AUTHKEY" --dry-run=client  -o yaml | kubectl apply -f -

  echo smtp and sms related configurations set.
  return 0
}
# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
msg_gateway   # calling function
