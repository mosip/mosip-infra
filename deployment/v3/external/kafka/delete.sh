#!/bin/sh
# Uninstalls kafka
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=kafka
while true; do
    read -p "Are you sure you want to delete kafka helm chart? Y/n ?" yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete kafka
        helm -n $NS delete kafka-ui
        break
      else
        break
    fi
done
