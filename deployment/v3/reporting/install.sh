#!/bin/sh
## This script install all required components for reporting framework.

## Variables
NS=reporting
MY_CONFIG="--kubeconfig $1" 


echo Add helm repos
helm repo add incubator https://charts.helm.sh/incubator #for kafka
helm repo add stable https://charts.helm.sh/stable  # for spark
helm repo update

## Create namespace
kubectl $MY_CONFIG create namespace $NS

## Install kafka and Zookeeper
helm $MY_CONFIG -n $NS install kafka incubator/kafka --set external.enabled=true --set persistence.enabled=false --wait

## Install kafka-client pod and debezium connector
helm $MY_CONFIG -n $NS install kafka-essentials ./charts/kafka-essential --wait

# Create required topics for kafka-client
kubectl $MY_CONFIG -n $NS exec $CLIENT_POD -- kafka-topics --zookeeper kafka-zookeeper:2181 --topic connect-offsets --create --partitions 1 --replication-factor 1
kubectl $MY_CONFIG -n $NS exec $CLIENT_POD -- kafka-topics --zookeeper kafka-zookeeper:2181 --topic connect-configs --create --partitions 1 --replication-factor 1
kubectl $MY_CONFIG -n $NS exec $CLIENT_POD -- kafka-topics --zookeeper kafka-zookeeper:2181 --topic connect-status --create --partitions 1 --replication-factor 1


## Configure Postgre essentials

# Assumed Postgres is installed in 'postgres' namespace with extended.conf as extended config.

## Copy db secrets to current namespace
./copy_secret.sh $NS $MY_CONFIG

## Install Spark
helm $MY_CONFIG -n $NS install spark stable/spark --set Worker.Image=nitish2087/spark-worker --set Worker.ImageTag=latest
