#!/bin/sh
# Uninstalls softhsm
## Usage: ./delete_ida.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=ida
while true; do
    read -p "Are you sure you want to delete Softhsm IDA helm charts? Y/n ?" yn
    if [ $yn == "Y" ]
      then
        helm -n $NS delete softhsm-ida
        break
      else
        break
    fi
done
