## Checks while deployment is in progress

* All pods should be 'green' on kubernetes dashboard, or if you are on command line, both these commands  must show pods in 1/1 or 2/2 state.
```
$ kc1 get pods -A
$ kc2 get pods -A
```
Some pods that show status `0/1 Complete` are Kubernetes jobs - they will not turn 1/1.

* Note the following namespaces:

|Module|Namespace|
|---|---|
|MOSIP modules|default|
|Kubernetes dashboard|kubernetes-dashboard|
|Grafana|monitoring|
|Prometheus|monitoring|
|Filebeat|monitoring|
|Ingress Controller|ingress-nginx|

To check pods in a particular namespace. Example:
```
$ kc2 -n monitoring get pods
```

* If any pod is 0/1 then the Helm install command timesout after 20 minutes.

* Following are some useful commands:
```
$ kc1 delete pod <pod name>  # To restart a pod
$ kc2 describe pod <pod name> # Details of a pod
$ kc1 logs <pod name>  # Logs of a pod
$ kc2 logs -f <pod name> # Running log
$ helm1 list # All helm installs in mzcluster
$ helm2 list # All helm installs in dmzcluster
```
Some pods have logs available in `logger-sidecar` as well.  These are application logs.  

* To re-run a module, helm delete module and then start with playbook. Example:
```
$ helm1 delete regproc
$ helm2 delete dmzregproc
$ an playbooks/regproc.yml
```

## Module basic sanity checks

* [Pre-registration](../test/prereg/README.md)
* [Registration Processor](../test/regproc/README.md)
* [Registration Client](../test/regclient/README.md)
