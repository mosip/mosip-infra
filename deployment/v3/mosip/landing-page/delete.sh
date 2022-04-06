#!/bin/sh
# Uninstalls landing page
NS=landing-page
while true; do
    read -p "Are you sure you want to delete landing page chart?(Y/n) " yn
    if [ $yn = "Y" ]
      then
        helm -n $NS delete landing-page
        break
      else
        break
    fi
done
