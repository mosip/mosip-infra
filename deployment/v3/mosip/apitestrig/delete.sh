#!/bin/sh
# Uninstalls apitestrig
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=apitestrig
while true; do
    read -p "Are you sure you want to delete apitestrig helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete apitestrig
        break
      else
        break
    fi
done
