#!/bin/sh
# Uninstalls resident-app
NS=resident
while true; do
    read -p "Are you sure you want to delete resident-app helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete resident-app
        break
      else
        break
    fi
done
