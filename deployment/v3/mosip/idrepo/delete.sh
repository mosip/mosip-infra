#!/bin/sh
# Uninstalls idrepo services
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=idrepo
while true; do
    read -p "Are you sure you want to delete idrepo helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete idrepo-saltgen
        helm -n $NS delete credential
        helm -n $NS delete credentialrequest
        helm -n $NS delete identity
        helm -n $NS delete vid
        break
      else
        break
    fi
done
