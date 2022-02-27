# Logging

## Kibana
 Kibana connects to Elasticsearch. Make sure you have a domain like `kibana.sandbox.xyz.net` pointing to your internal load balancer included in [global configmap](../cluster/global_configmap.yaml.sample).

## Install Elasticsearch, Kibana and Istio addons
```sh 
./install.sh
```

## Instal Rancher FluentD system
* Install `logging` from `Apps and marketplace` within the Rancher UI.

## Configure Rancher FluentD to collect logs from mosip services
* To route the logs to elasticsearch, create ClusterOutputs as belows:
    * Select `Logging` from `Cluster Explorar` section on top left corner of Rancher dashboard's 'Cluster Explorar' page.
    * Select `ClusterOutputs` from `Logging` screen and create one with below mentioned configuration:
        *  Name: eg. elasticsearch.
        *  Description: small description.
        *  select `Elasticsearch` as Output.
        *  update the `Target` as below and save the same.
            ```
            http://elasticsearch-master:9200 
            ```
            Note :  Make sure that you select Output as `Elasticsearch`, Target as `http`,  Host as `elasticsearch-master` and Port as `9200`.
    * Select `ClusterFlows` from `Logging` screen and create one with below mentioned configuration: 
        * Name: eg. elasticflow
        * Description: small description
        * select `Filters` and replace the contents with the contents of [filter.yml](./filter.yml)
        * select Outputs as the name of the ClusterOutputs and save the same.

Note that with this filter any json object received in `log` field will be parsed into individual fields and indexed.

* TODO: Issues: Elasticsearch and Kibana pod logs are not getting recorded.  Further, setting up Cluster Flow for pods specified by pod labels doesn't seem to work.  Needs investigation.

## View logs
* Open Kibana console `https://<kibana host name>//` (`hostname` in `kibana_values.yaml`)
* In Kibana console add Index Pattern "fluentd*" under Stack Management.
* View logs in Home->Analytics->Discover.

## Troubleshooting
* If MOSIP logs are not seen, check if all fields here have quotes (except numbers):
Log pattern in [mosip-config](https://github.com/mosip/mosip-config/blob/develop3-v3/application-default.properties) property `server.tomcat.accesslog.pattern`.
