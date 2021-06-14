#!/bin/sh

NS=reporting
echo Add helm repos
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator # for kafka
helm repo add stable # for spark
helm repo update

## Install kafka-essentials
helm -n $NS install kafka-essential /kafka-essentials

## Install Spark
#install helm chart
helm -n $NS install spark stable/spark

#get pod name of spark-worker
PODNAME=kubectl -n $NS get pods -o go-template --template ' {{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | awk '{print $1}' | grep spark-worker | tail -n 1

#copy jobs to spark-worker
kubectl -n $NS cp jobs/*.py $PODNAME:opt/spark/examples/src/main/python/


## Run jobs
#job-1
kubectl -n $NS exec -it $PODNAME -- /opt/spark/bin/spark-submit --packages org.apache.spark:spark-streaming-kafka-assembly_2.10:1.5.1 --class org.apache.spark.examples.SparkPi   --master spark://spark-master:7077  /opt/spark/examples/src/main/python/<python-job>.py 1000

#job-2

#job-3

