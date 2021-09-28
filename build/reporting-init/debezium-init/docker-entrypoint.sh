#!/bin/bash

DEBEZIUM_FILE="/debez-connector/debez-sample-conn.api"

for i in $(seq 1 $NUMBER_DEBEZ_CONN); do
  tmp1="DEBEZ_DB_NAME_$i"
  tmp2="DEBEZ_TABLE_LIST_$i"
  DB_NAME=${!tmp1} DB_TABLES=${!tmp2} sh -x $DEBEZIUM_FILE
  sleep $DELAY_BETWEEN_CONNECTORS
done
