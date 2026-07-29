#!/bin/bash
# Uninstalls idrepo-apitestrig release
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

function deleting_apitestrig() {
  NS=apitestrig
  RELEASE_NAME=idrepo-apitestrig
  while true; do
      read -p "Are you sure you want to delete $RELEASE_NAME helm chart?(Y/n) " yn
      if [ "$yn" = "Y" ]
        then
          helm -n $NS delete $RELEASE_NAME
          break
        else
          break
      fi
    done
  return 0
}

set -e
set -o errexit
set -o nounset
set -o errtrace
set -o pipefail
deleting_apitestrig
