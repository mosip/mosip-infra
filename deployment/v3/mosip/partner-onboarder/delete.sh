#!/bin/sh
# Uninstalls partner-onboarder helm
## Usage: ./delete.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi
NS=onboarder
while true; do
    read -p "Are you sure you want to delete all partner-onboarder ?(Y/n) " yn
    if [ $yn = "Y" ]; then
      echo Deleting partner-onboarder helm
      kubectl -n $NS --ignore-not-found=true  delete configmap global
      helm -n $NS delete partner-onboarder
      break
    fi
done