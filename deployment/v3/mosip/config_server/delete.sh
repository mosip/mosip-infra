#!/bin/sh
# Uninstalls config server
NS=config-server
while true; do
    read -p "Are you sure you want to delete config-server helm charts?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        kubectl delete ns config-server
        break
      else
        break
    fi
done
