#!/bin/bash
# Uninstalls the conf-secrets helm chart
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

function deleting_conf_secrets() {
  NS=conf-secrets
  SECRET_NAME=conf-secrets-various
  BACKUP_DIR=./conf_secrets_backup
  mkdir -p $BACKUP_DIR
  while true; do
      read -p "Are you sure you want to delete the conf-secrets helm chart?(Y/n) " yn
      if [ $yn = "Y" ]
        then
          # Backup the conf-secrets
          kubectl get secret $SECRET_NAME -n $NS -o yaml > $BACKUP_DIR/$SECRET_NAME.yaml
          helm -n $NS delete conf-secrets
          echo "deleted conf-secrets helm chart"
          echo "Backup of conf-secrets is taken and stored in conf_secrets_backup directory."
          break
        else
          break
      fi
  done
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
deleting_conf_secrets   # calling function