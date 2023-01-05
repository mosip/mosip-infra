#!/bin/bash
# Uninstalls all prereg helm charts

function deleting_prereg() {
  while true; do
      read -p "Are you sure you want to delete all prereg helm charts?(Y/n) " yn
      if [ $yn = "Y" ]
        then
          kubectl -n prereg delete -f rate-control-envoyfilter.yaml
          helm -n prereg delete prereg-gateway
          helm -n prereg delete prereg-captcha
          helm -n prereg delete prereg-application
          helm -n prereg delete prereg-batchjob
          helm -n prereg delete prereg-booking
          helm -n prereg delete prereg-datasync
          helm -n prereg delete prereg-ui
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
deleting_prereg   # calling function