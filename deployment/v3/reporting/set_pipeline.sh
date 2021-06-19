#!/bin/bash

## This script will set the pipeline db - kafka - spark

NS=reporting
MY_CONFIG="--kubeconfig $3"
SPARK_MASTER_PORT=7077 #by-default, change it and specify with helm command for installing spark
SPARK_USER=1000 #by-default for stable/spark, change it and specify while spark-submit
SPARK_CHART_VERSION=$(helm -n $NS show chart stable/spark | grep appVersion | cut -d":" -d" " -f2-)


## Configure debezium to call kafka-connect api for creating topics in kafka

CONNECT_SERVICE=$(kubectl $MY_CONFIG -n $NS get service -o go-template --template ' {{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | awk '{print $1}' | grep debezium | tail -n 1)

# Use HTTP client (cURL), make the following request to the Kafka Connect API. This will configure a new Debezium PostgreSQL connector. This connector monitors the pgoutput stream for operations on the whitelisted tables:

# Copy secret to env for passing to JSON:
DB_SECRET=$(kubectl $MY_CONFIG -n $NS get secret db-common-secrets -o jsonpath='{.data.db-dbuser-password}' | base64 --decode)

#######----to be fixed----
#curl -X POST http://$CONNECT_SERVICE.$NS/connectors -H 'Content-Type: application/json' -d @$1

## To list the kafka topics:
kubectl $MY_CONFIG -n $NS exec kafka-client -- kafka-topics --zookeeper kafka-zookeeper:2181 --list

## To tail the Kafka topic <topic-name> to show database transactions being written to the topic from Kafka Connect:
#kubectl $MY_CONFIG -n $NS exec kafka-client -- kafka-console-consumer --topic <topic-name> --from-beginning --bootstrap-server kafka:9092

## Submit jobs to spark master, jobs will enable spark to stream from kafka topic to indices in elasticsearch
 
# Get pod name of spark-worker
PODNAME=$(kubectl $MY_CONFIG -n $NS get pods -o go-template --template ' {{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | awk '{print $1}' | grep spark-worker | tail -n 1)

# Copy jobs to spark-worker
kubectl $MY_CONFIG -n $NS cp $2 $PODNAME:opt/spark/examples/src/main/python/

## Run jobs

# Job-1
kubectl $MY_CONFIG -n $NS exec -it $PODNAME -- /opt/spark/bin/spark-submit --packages org.apache.spark:spark-streaming-kafka-assembly_2.10:$SPARK_CHART_VERSION --class org.apache.spark.examples.SparkPi   --master spark://spark-master:$SPARK_MASTER_PORT  /opt/spark/examples/src/main/python/$(basename "$2") $SPARK_USER

# Job-2

# Job-3

