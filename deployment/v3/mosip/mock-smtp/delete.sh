#!/bin/sh
# Uninstalls mock smtp
NS=mock-smtp
while true; do
    read -p "Are you sure you want to delete mock smtp helm chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete mock-smtp
        break
      else
        break
    fi
done