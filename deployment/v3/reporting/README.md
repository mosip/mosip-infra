## Reporting framework

### Introduction
Reference reporting framework for real-time streaming data and visualization.  

#### High level architecture

![](../docs/images/reporting_architecture.png)


## Installation

#### 1. Prerequisites

- It is assumed that Elasticsearch and Kibana are already installed in the cluster.
- Assumed Postgres is already installed with `extended.conf` as extended config.

#### 2. Kafka & Zookeeper & Debezium-Connector & Elasticsearch-Connector

```
$ KUBECONFIG="<kube-config-file>" ./install.sh
```

#### 3. Establish Connection/Pipeline
After all components are installed, for every db/table that is to be connected/synced to elasticsearch:
- Edit the `./create_connector_api_calls.sample` file, accordingly. Edit only the lines, in the beginning, that are marked to be edited. Need not edit the rest.
- After editing and renaming the file, Run the following;
```
$ KUBECONFIG="<kube-config-file>" ./run_connect_api.sh create_connector_api_calls
```
- NOTE:
	- The db user used in the connector has to have 'REPLICATION' permission (or 'SUPERUSER' permission) set in the role, for debezium to capture.

## Cleanup/Uninstall

- First run the delete api call, which deletes the connectors. Then to uninstall everything, delete the namespace.
```
$ KUBECONFIG="<kube-config-file>" ./run_connect_api.sh delete_connector_api_calls
$ KUBECONFIG="<kube-config-file>" kubectl delete ns reporting
```
- Cleanup:
	- The delete api call is not deleting the replication slot in database created by debezium, if the user doesnt have superuser permissions. So will have to login to the db, and manually delete the replication slot in that case. TODO: look for better alternative.
	```
	postgres=# select pg_drop_replication_slot('debezium');
	```
	- Also, if necessary will have to manually delete the new indices created in elasticsearch.
