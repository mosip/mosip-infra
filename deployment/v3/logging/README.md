# Logging

## Kibana
* Make sure you have a domain like `kibana.sandbox.xyz.net` pointing to your internal load balancer included in [global configmap](../cluster/global_configmap.yaml.sample).
* Review the settings in `kibana_values.yaml`.  Set `ingress.hostname`.
* Kibana connects to Elasticsearch. 

## Install Elasticsearch, Kibana and Istio addons
```sh
./install.sh
```

## Rancher FluentD system
* Install 'logging' from 'Apps and marketplace" within the Rancher UI.
* To route the logs to elasticsearch, set ClusterOutputs as
```
http://elasticsearch-master:9200 
```
Note :  Make sure that you select output as "Elastic search", Target as "http",  Host as "elasticsearch-master" and port as 9200.

* Set ClusterFlow Filter with `filter.yaml`.   Copy the contents of filter.yaml into the clusterflow Filters.
* Set the Outputs within the Cluster Flow as the name of the ClusterOutputs.

Note that with this filter any json object received in `log` field will be parsed into individual fields and indexed.

* TODO: Issues: Elasticsearch and Kibana pod logs are not getting recorded.  Further, setting up Cluster Flow for pods specified by pod labels doesn't seem to work.  Needs investigation.

## View logs
* Open Kibana console `https://<kibana host name>//` (`hostname` in `kibana_values.yaml`)
* In Kibana console add Index Pattern "fluentd*" under Stack Management.
* View logs in Home->Analytics->Discover.

## Troubleshooting
* If MOSIP logs are not seen, check if all fields here have quotes (except numbers):
Log pattern in [mosip-config](https://github.com/mosip/mosip-config/blob/v3/application-default.properties) property `server.tomcat.accesslog.pattern`.
