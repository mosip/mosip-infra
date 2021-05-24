## Batch Processing
Batch processing is used in case of streaming data seamlessly at intervals. Here, we are using ELK stack toolkit for achieving the same, although the components are deployed and configured separately to avoid dependency and provide modularity.
### Pre-requisites
- A database : e.g Postgres DB.
- Logstash: to crawl data from database transform and index to elastic search.
- Elasticsearch: as data-index and persistence store.
- Kibana: visualization tool to create and view dashboards and reports.
### Installation
Please follow the installation script provided [here](installation.sh).
### How it works !
- We have four mentioned components: Postgres DB, Logstash, Elasticsearch and Kibana.  
- The flow of execution looks like this: 
![](https://github.com/mosip/reporting/blob/1.1.3/reporting-framework/reporting-architecture-batch.png)
- For smooth flow of data which is centric to main database, it's good to operate and take logs from it's replica.
- In logstash configuration, we need to create a `logstash pipeline` which will do the following jobs:
	- Connect to database via postgres [adapter](https://jdbc.postgresql.org/download/postgresql-42.2.19.jre6.jar).
	- Run the SQL query to extract logs from database/tables.
	- Connect to elasticsearch to output indexes to.
- In newer versions of logstash, we have to use `xpack` authentication tool to connect to elasticsearch. For this, put these lines  in `logstash pipeline` script (sample [here](logstash_pipeline_sample.yaml)):
	```
	logstashConfig:
		 logstash.yml: |
	    xpack.monitoring.enabled: true
	    xpack.monitoring.elasticsearch.hosts: [http://elasticsearch-master:9200] //elasticsearch master's svc url.
	```
- The pipeline essentials are passed as input{} and output{} section in `logstash pipeline` script under this section: 
	```
	logstashPipeline:
		logstash.conf |
	```
	logstash.conf will be mounted as a ConfigMap inside logstash pods.
	**Note**: The `logstash pipeline` script is the modified `values.yaml` for logstash helm chart.
- We will also be required to mount postgres adapter inside logstash pod, so that it'll be able to find all required things. We can do it via ConfigMap or kubectl copy command.
- After pipeline will be executed successfully, we'll be able to see indexes in elasticsearch via APIs: `/elasticsearch/_cat/indices ` . For example:
	```
	$ curl -L http://mzworker0.sb:30080/elasticsearch/_cat/indices | grep logstash
	```
- Connect to Kibana UI, create a dashboard and configure it for data source `Logstash-*` and create visuals as per your requirement.
