#!/bin/sh
# Uninstalls mock mv
NS=abis
while true; do
    read -p "Are you sure you want to delete mock mv helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete mock-mv
        break
      else
        break
    fi
done