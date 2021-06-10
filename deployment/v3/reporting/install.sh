#!/bin/sh
# Installs Kafka-Debezium and Spark
NS=reporting

echo Add helm repo
helm repo add <>
helm repo update

echo Installing kafka
helm -n $NS install kafka bitnami/kafka

echo Installing Spark

