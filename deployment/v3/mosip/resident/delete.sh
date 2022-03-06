#!/bin/sh
# Uninstalls resident 
NS=resident
while true; do
    read -p "Are you sure you want to delete resident helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete resident
        break
      else
        break
    fi
done
