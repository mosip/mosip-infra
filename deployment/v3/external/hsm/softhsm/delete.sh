#!/bin/sh
# Uninstalls softhsm
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=softhsm
while true; do
    read -p "Are you sure you want to delete Softhsm helm charts? Y/n ?" yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete softhsm-kernel
        helm -n $NS delete softhsm-ida
        helm -n $NS delete softhsm-idp
        break
      else
        break
    fi
done
