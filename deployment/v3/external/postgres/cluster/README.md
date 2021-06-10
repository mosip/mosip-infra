# Postgres installation on Kubernetes cluster

## Dependency
If you would like to expose postgres access from outside cluster, run ingress controller as given [here](../../../cluster/on-prem/README.md)

## Helm charts 
* Create `postgres` namespace:
```
$ kubectl create ns postgres
```
* Install following chart. See documentation of the chart for various options
```
helm -n postgres install postgres bitnami/postgresql
```
* A random password will get assigned for `postgres` user if you have not specified a password.  The password may be obtained using following script:
```
$ ./get_pwd.sh
```

## Ingress
To enable postgres access over secure internal channel (with wireguard front end bastion host) it is assumed that istio ingress controller has port 5432 opened up.

Update `hosts` in `gateway.yaml` and run
```
$ kubectl -n postgres apply -f istio/gateway.yaml
$ kubectl -n postgres apply -f istio/virtualservice.yaml
```
## Test
* Make sure docker is running from machine you are testing.
* Connect to postgres:
```
$ docker run -it --rm postgres psql -h <hostname pointing to load balancer> -U postgres -p 5432
```
## Initialize DB
* Review `values.yaml` for  which DBs you would like to initialize.
* Run init postgres helm chart to create necessary DB, users, roles etc:
```
$ helm repo update mosip
$ helm -n postgres install postgres-init mosip/postgres-init -f values.yaml
```
Be aware of version of helm chart corresponding to mosip version.

## Troubleshooting
* If you face login issues even when the password entered is correct, it could be due to previous PVC, and PV.  Delete them, but exercise caution as this will delete all persistent data.

