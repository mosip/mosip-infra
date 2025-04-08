#!/bin/bash

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

function post_logging_setup() {
  echo "Adding Index Lifecycle Policy and Index Template to Elasticsearch"
  kubectl exec -it elasticsearch-master-0 -n cattle-logging-system -- curl -XPUT "http://elasticsearch-master:9200/_ilm/policy/3_days_delete_policy" -H 'Content-Type: application/json' -d'
  {
    "policy": {
      "phases": {
        "delete": {
          "min_age": "3d",
          "actions": {
            "delete": {}
          }
        }
      }
    }
  }'
  kubectl exec -it elasticsearch-master-0 -n cattle-logging-system -- curl -XPUT "http://elasticsearch-master:9200/_index_template/logstash_template" -H 'Content-Type: application/json' -d'
  {
    "index_patterns": ["logstash-*"],
    "template": {
      "settings": {
        "index": {
          "lifecycle": {
            "name": "3_days_delete_policy"
          }
        }
      },
      "aliases": {},
      "mappings": {}
    }
  }'

  echo "Configure Rancher FluentD"
  kubectl apply -f $WORKDIR/utils/logging/clusteroutput-elasticsearch.yaml
  kubectl apply -f $WORKDIR/utils/logging/clusterflow-elasticsearch.yaml

  echo "Load Dashboards"
  $WORKDIR/utils/logging/load_kibana_dashboards.sh $WORKDIR/utils/logging/dashboards ~/.kube/config
  echo "Dashboards loaded"
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
post_logging_setup   # calling function  
