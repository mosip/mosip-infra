#!/bin/sh
# Uninstalls all postgres resources
NS=postgres
while true; do
    read -p "Are you sure you want to delete ALL postgres helm charts? Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        helm -n $NS delete postgres
        kubectl -n $NS delete gateway postgres
        kubectl -n $NS delete vs postgres
        break
      else
        break
    fi
done
