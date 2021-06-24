# Input params to this job
# ./python_job.py elasticsearch_host elasticsearch_port 
import sys
import os
from pyspark import SparkContext
from pyspark.streaming import StreamingContext
from pyspark.rdd import RDD
from pyspark.streaming import DStream
from pyspark.streaming.kafka import KafkaUtils
from pyspark.streaming.dstream import TransformedDStream
from pyspark.streaming.util import TransformFunction
from datetime import datetime
from elasticsearch import Elasticsearch
import pprint, StringIO
import json
import datetime

## topic naming convention: https://debezium.io/documentation/reference/connectors/postgresql.html#postgresql-topic-names  
KAFKA_TOPIC=postgres.audit.app_audit_log
INDEX_NAME=postgres-audit-app-audit-log

def sendRecord(rdd):
    list_elements = rdd.collect()
    for element in list_elements:
        record = json.loads(element)
        docId = record['log_id']
        print(docId)
        record['date'] = convertEpochDate(record['action_dtimes'])
        audit_req_dtimes = convertEpochDateTime(record['action_dtimes'])
        audit_log_dtimes = convertEpochDateTime(record['log_dtimes'])
        record['action_dtimes'] = audit_req_dtimes
        record['log_dtimes'] = audit_log_dtimes
        print(record)
        res = es.index(index=indexname, id=docId, body=record)
        print(res['result'])
        es.indices.refresh(index=indexname)

def convertEpochDateTime(epochDateTime):
    if epochDateTime is not None:
       dtimes_str = str(epochDateTime)
       dtimes_upd = dtimes_str[0:-6]
       sDateTime = datetime.datetime.fromtimestamp(int(dtimes_upd)).strftime('%Y-%m-%dT%H:%M:%S.000Z')                                                   
       return sDateTime
    else:
       return None

def convertEpochDate(epochDate):
    if epochDate is not None:
       dtimes_str = str(epochDate)
       dtimes_upd = dtimes_str[0:-6]
       sDate = datetime.datetime.fromtimestamp(int(dtimes_upd)).strftime('%Y-%m-%d')
       return sDate
    else:
       return None
    
def main():
    sc = SparkContext(appName="KafkaStreamFromPostgresDB")
    ssc = StreamingContext(sc, 2)

    eshost = sys.argv[1]
    esuser = "elastic" # Not required
    espassword = "elastic" # Not required
    esport = sys.argv[2]
    indexname = INDEX_NAME 
    es = Elasticsearch(eshost, http_auth=(esuser, espassword), port=esport)
    p=es.ping()
    print(p)
    
    ##Connection to Kafka using Direct streaming methods.
    brokers, topic = kafka-9092, KAFKA_TOPIC
    kStream = KafkaUtils.createDirectStream(ssc,[topic],{"metadata.broker.list": brokers, "auto.offset.reset" : "smallest"})
    dbRecord = kStream.map(lambda x: x[1])
    dbRecord.map(lambda x: json.loads(x[1]))
    dbRecord.pprint()

    dbRecord.foreachRDD(sendRecord)

    ssc.start()
    ssc.awaitTermination()

if __name__=="__main__":
    main()
