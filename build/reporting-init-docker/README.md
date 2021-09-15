## Docker for reporting-init

```sh
$ rm -r connector_api_calls kibana_saved_objects
$ mkdir connector_api_calls kibana_saved_objects
$ cp ../../deployment/v3/reporting/ref_connector_api_calls/*.api connector_api_calls
$ cp ../../deployment/v3/reporting/ref_kibana_saved_objects/* kibana_saved_objects
$ docker build .
```
