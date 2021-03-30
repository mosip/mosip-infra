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
helm -n postgres install postgres bitnami/postgresql --set replication.enabled=true
```
* A random password will get assigned for `postgres` user if you have not specified a password.  The password may be obtained using following script:
```
$ ./get_pwd.sh
```

## Ingress
It is assumed that while deploying ingress controller you have enabled service port 5432 and the same is seen on the load balancer.

## Test
* Make sure docker is running from machine you are testing.
* Connect to postgres:
```
$ docker run -it --rm postgres psql -h <hostname pointing to load balancer> -U postgres -p 5432
```

## Troubleshooting
* If you face login issues even when the password entered is correct, it could be due to previous PVC, and PV.  Delete tthem, but exercise caution as this will delete all persistent data.

