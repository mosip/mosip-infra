## Reporting framework

### Introduction
Reference reporting framework for real-time streaming data and visualization.
## Installation
#### Elasticsearch and Kibana
It is assumed that Elasticsearch and Kibana are already installed in the cluster (assumed in namespace called `logging`).
Assumed Postgres is installed in namespace called `postgres` with `extended.conf` as extended config.
#### Kafka and Spark
```
	$ ./install.sh <kube-config-file>
```
## Streaming 
```
	$ ./set_pipeline.sh <db.json> <python-job-file> <kube-config-file>
```
