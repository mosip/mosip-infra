# Istio

## Install
* Install `istioctl` as given [here](https://istio.io/latest/docs/setup/getting-started/#download)
* Run
```
./install.sh
```
1. Point your domain names to the nginx node internal or public ip respectively.
2. To check the connections you may install [httpbin](../../../utils/httpbin)

## Istio injection
To enable Istio injection in a namespace:
```
kubectl label ns <namespace> istio-injection=enabled --overwrite
```
