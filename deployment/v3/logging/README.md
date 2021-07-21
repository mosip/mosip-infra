# Logging

## Elasticsearch  
* Install Elastic search using Bitnami Elasticsearch helm charts.  
* Before install review the persistence, storage size, storage class etc. in values file of the chart. Enable persistence for production setups.
* Cloud: You may use cloud provider's Elasticsearch hosted application in which case you don't need to install the same as given above. 

## Kibana
* Make sure you have a domain like `kibana.sandbox.xyz.net` pointing to your internal load balancer included in [global configmap](../cluster/global_configmap.yaml.sample).
* Kibana connects to Elasticsearch. 
* Review the settings in `kibana_values.yaml`.  Set `ingress.hostname`.
* We install Kibana with a name *other* than `kibana` to avoid [this issue](https://github.com/bitnami/charts/issues/6099).

## Install
```sh
./install.sh
```

## Rancher FluentD system
* Enable logging in Rancher
* To route the logs to elasticsearch, set ClusterOutputs as
```
http://elasticsearch-master:9200
```
* Set ClusterFlow Filter with `filter.txt`.  Note that with this filter any json object received in `log` field will be parsed into individual fields and indexed.  If you don't want to keep the original log message (to save storage, for e.g.) set `reserved_data: false`.
* TODO: Issues: Elasticsearch and Kibana pod logs are not getting recorded.  Further, setting up Cluster Flow for pods specified by pod labes doesn't seem to work.  Needs investigation.

## View logs
* Open Kibana console `https://<kibana host name>//` (`hostname` in `kibana_values.yaml`)
* In Kibana console add Index Pattern "fluentd" under Stack Management. 
* View logs in Home->Analytics->Discover.

## Troubleshooting
* If MOSIP logs are not seen, check if all fields here have quotes (except numbers):
Log pattern in [mosip-config](https://github.com/mosip/mosip-config/blob/v3/application-default.properties) property `server.tomcat.accesslog.pattern`.
