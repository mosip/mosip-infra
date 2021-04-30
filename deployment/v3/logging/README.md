# Logging

## Elasticsearch  
* Install Elastic search using Bitnami Elasticsearch helm charts.  
* Before install review the persistence, storage size, storage class etc. in values file of the chart.
* Install:
```
$ helm repo update
$ helm -n logging install elasticsearch bitnami/elasticsearch -f <your_values.yaml>
``` 
* Cloud: You may use cloud provider's Elasticsearch hosted application in which case you don't need to install the same as given above. 

## Kibana
* Kibana connects to Elasticsearch. 
* Review the settings in `kibana_values.yaml`.  Set `ingress.hostname`.
* Install Kibana with a name *other* than `kibana` to avoid [this issue](https://github.com/bitnami/charts/issues/6099).
```
$ helm -n logging install mykibana bitnami/kibana -f kibana_values.yaml
```
## Rancher FluentD system
* Enable logging in Rancher
* To route the logs to elasticsearch, set ClusterOutputs as
```
http://elasticsearch-master.logging:9200
```
* Set ClusterFlow Filter to with `filter.txt`.  Note that any json object received in `log` field will be parsed into individual fields and indexed.  If you don't want to keep the original log message (to save storage, for e.g.) set `reserved_data: false`.
* TODO: Issues: Elasticsearch and Kibana logs are not getting recorded.  Further, setting up Cluster Flow for pods specified by pod labes doesn't seem to work.  Needs investigation.

## View logs
* Open Kibana console `https://<kibana host name>//` (`hostname` in `kibana_values.yaml`)
* In Kibana console add Index Pattern "fluentd" under Stack Management. 
* View logs in Home->Analytics->Discover.

## Troubleshooting
* Json under field `log` not parsed.  This could be due to json values not containing "quotes" for strings. For MOSIP modules check log pattern in [mosip-config](https://github.com/mosip/mosip-config/blob/v3/application-default.properties) property `server.tomcat.accesslog.pattern`.
