#!/bin/sh
# This script submits a spark job
# Usage: ./run_spark_job <python job file>
NS=reporting
$SPARK_POD=kubectl -n $NS get pods | grep .. 
kubectl -n $NS cp $1 $SPAK_PAD:<path> 
kubectl -n $NS <spark job command> 

