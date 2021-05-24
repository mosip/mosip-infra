# Kafka

## Install
```
$ kubectl create ns kafka
$ helm repo update
$ helm -n kafka install kafka bitnami/kafka -f values.yaml
```
