#!/bin/bash
# Uninstalls all regproc helm charts

function deleting_regproc() {
  NS=regproc
  while true; do
      read -p "Are you sure you want to delete all regproc helm charts?(Y/n) " yn
      if [ $yn = "Y" ]
        then
          helm -n $NS delete regproc-salt
          helm -n $NS delete regproc-workflow
          helm -n $NS delete regproc-status
          helm -n $NS delete regproc-camel
          helm -n $NS delete regproc-pktserver
          helm -n $NS delete regproc-group1
          helm -n $NS delete regproc-group2
          helm -n $NS delete regproc-group3
          helm -n $NS delete regproc-group4
          helm -n $NS delete regproc-group5
          helm -n $NS delete regproc-group6
          helm -n $NS delete regproc-group7
          helm -n $NS delete regproc-notifier
          helm -n $NS delete regproc-trans
          helm -n $NS delete regproc-reprocess
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
deleting_regproc   # calling function