#!/bin/sh

NS=reporting

#Install kafka and Zookeeper
helm -n $NS install kafka incubator/kafka --set external.enabled=true --set persistence.enabled=false

#Install kafka-client pod
kubectl -n $NS create -f kafka-client-deploy.yaml

# create required topics for kafka-client
kubectl -n $NS exec kafka-client -- kafka-topics --zookeeper kafka-zookeeper:2181 --topic connect-offsets --create --partitions 1 --replication-factor 1
kubectl -n $NS exec kafka-client -- kafka-topics --zookeeper kafka-zookeeper:2181 --topic connect-configs --create --partitions 1 --replication-factor 1
kubectl -n $NS exec kafka-client -- kafka-topics --zookeeper kafka-zookeeper:2181 --topic connect-status --create --partitions 1 --replication-factor 1

#Create configmap and mount to pg --- recommended to put this in postgre installation
kubectl -n $NS create configmap --from-file=../extended.conf postgresql-config
helm -n $NS install postgres --set extendedConfConfigMap=postgresql-config <other-args> stable/postgresql
