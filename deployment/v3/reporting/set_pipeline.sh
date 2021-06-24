#!/bin/bash

NS=reporting

# Init db connections using helm

helm -n $NS install <job_name>-init mosip/debezium-init -f jobs/job_name_values.yaml
 

# Copy jobs to spark-worker
kubectl $MY_CONFIG -n $NS cp $2 $PODNAME:opt/spark/examples/src/main/python/

## Run jobs

# Job-1
kubectl $MY_CONFIG -n $NS exec -it $PODNAME -- /opt/spark/bin/spark-submit --packages org.apache.spark:spark-streaming-kafka-assembly_2.10:$SPARK_CHART_VERSION --class org.apache.spark.examples.SparkPi   --master spark://spark-master:$SPARK_MASTER_PORT  /opt/spark/examples/src/main/python/$2 1000

# Job-2

# Job-3

