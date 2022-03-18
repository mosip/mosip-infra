#!/bin/sh
# Deletes the secret to pull private dockers.
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

while true; do
    read -p "Are you sure you want to delete regsecret?(Y/n) " yn
    if [ $yn = "Y" ]
      then
         kubectl delete secret regsecret
        break
      else
        break
    fi
done
