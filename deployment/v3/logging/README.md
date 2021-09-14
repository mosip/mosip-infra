# Logging

## Elasticsearch  
* Review `es_values.yaml` for Elasticsearch installation.  
* Enable persistence for production setups. Note that default storage class shall be used. Otherwise specify the same in `es_values.yaml`
* Cloud: You may use cloud provider's Elasticsearch hosted application in which case you don't need to install the same as given above. 

## Kibana
* Make sure you have a domain like `kibana.sandbox.xyz.net` pointing to your internal load balancer included in [global configmap](../cluster/global_configmap.yaml.sample).
* Review the settings in `kibana_values.yaml`.  Set `ingress.hostname`.
* Kibana connects to Elasticsearch. 
* _Note:_ We install Kibana with a name *other* than `kibana` to avoid [this issue](https://github.com/bitnami/charts/issues/6099).

## Install Elasticsearch, Kibana and Istio addons
```sh
./install.sh
```

## Rancher FluentD system
* Enable logging in Rancher using UI.
* To route the logs to elasticsearch, set ClusterOutputs as
```
http://elasticsearch-master:9200
```
* Set ClusterFlow Filter with `filter.txt`.  Note that with this filter any json object received in `log` field will be parsed into individual fields and indexed.  If you don't want to keep the original log message (to save storage, for e.g.) set `reserved_data: false`.
* TODO: Issues: Elasticsearch and Kibana pod logs are not getting recorded.  Further, setting up Cluster Flow for pods specified by pod labels doesn't seem to work.  Needs investigation.

## View logs
* Open Kibana console `https://<kibana host name>//` (`hostname` in `kibana_values.yaml`)
* In Kibana console add Index Pattern "fluentd" under Stack Management. 
* View logs in Home->Analytics->Discover.

## Troubleshooting
* If MOSIP logs are not seen, check if all fields here have quotes (except numbers):
Log pattern in [mosip-config](https://github.com/mosip/mosip-config/blob/v3/application-default.properties) property `server.tomcat.accesslog.pattern`.
