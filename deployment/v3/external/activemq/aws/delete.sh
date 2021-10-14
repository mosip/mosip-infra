#!/bin/sh
# Uninstalls Activemq
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=activemq
while true; do
    read -p "Are you sure you want to delete ActiveMQ helm chart? (Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete activemq
        break
      else
        break
    fi
done
