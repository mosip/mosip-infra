#!/bin/sh
# Uninstalls all Kernel helm charts 
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi
NS=kernel
while true; do
    read -p "Are you sure you want to delete ALL Kernel helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete auditmanager
        helm -n $NS delete authmanager
        helm -n $NS delete idgenerator 
        helm -n $NS delete masterdata
        helm -n $NS delete otpmanager
        helm -n $NS delete pridgenerator
        helm -n $NS delete ridgenerator
        helm -n $NS delete syncdata
        helm -n $NS delete notifier
        break
      else
        break
    fi
done
