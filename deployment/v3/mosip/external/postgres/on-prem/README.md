# Postgres installation

## Context
While production deployments will either use Postgres provided by a Cloud provider, or installed externally in the data center, for non-production deployment you may install Postgres as docker containers on the cluster.  It is possible to install high availablity production grade Postgres on cluster as well, however, whether the same approach can be scaled to full scale production is yet to evaluate and tested.  Having said that, the method outlined here will work for sandboxes and small pilot rollouts very well.

## Helm charts 
* Install following chart. See documentation of the chart for various options
```
helm install postgres bitnami/postgres
```
* To enable replication:
```
helm install postgres bitnami/postgresql --set replication.enabled=true
```
* A random password will get assigned for `postgres` user if you have not specified a password.  The password may be seen by inspecting Secrets:
```
$ kubectl describe secret postgres-postgresql
```
The secret is base64 encoded which may be decoded from Linux command line:
```
$ kubectl get secret postgres-postgresql -o template --template='{{index .data "postgresql-password"}}'
```
## Ingress TCP port
* Enable TCP port 5432 on ingress controller 
* Add TCP port 5432 listner to LoadBalancer (in case of AWS)

## Test
* Connect to postgres:
```
$ docker run -it --rm postgres psql -h <hostname pointing to load balancer> -U postgres -p 5432
```

## Troubleshooting
* If you face login issues even when the password entered is correct, it could be due to previous PVC, and PV.  Delete tthem, but exercise caution as this will delete all persistent data.

