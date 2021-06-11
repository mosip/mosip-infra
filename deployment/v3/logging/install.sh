#!/bin/sh
# Installs Elasticsearch
NS=logging

echo Create namespace logging
kubectl create namespace $NS

while true; do
    read -p "Have your reviewed kibana_values.yaml Y/n ?" yn
    if [[ $yn == "Y" ]]
      then
        echo Installing Bitnami Elasticsearch
        helm -n $NS install elasticsearch bitnami/elasticsearch -f es_values.yaml --wait

        echo Installing Kibana
        helm -n $NS install mykibana bitnami/kibana -f kibana_values.yaml
        break
      else
        break
    fi
done



