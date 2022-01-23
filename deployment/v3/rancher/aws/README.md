# Rancher on AWS EKS Cluster

## Overview
* Secure Rancher install
* Over wireguard
* HA
* Internal LB
* IAM (integrate in this cluster). Or point to an external one.

## AWS
Follow the procedure given [here](../../cluster/aws/README.md) to create a cluster on AWS.  Use the sample cluster config given in this folder - modify it according to your configuration.

## Nginx ingress

```
helm install \                               
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --version 3.12.0 \
  --create-namespace  \
-f nginx.values.yaml
```

## Set configmap 
* Edit configmap
    ```
    kubectl -n ingress-nginx edit cm  ingress-nginx-controller
    ```
* Add following data:
    ```
    data:
      use-forwarded-headers: "true"
      use-proxy-protocol: "true"
    ```
* Restart ingress controller
    ```
     kubectl -n ingress-nginx delete pod  <controller pod name> 
    ```

## Loadbalancer
The `nginx.values.yaml` specifies a AWS Network Loadbalancer (L4) be automatically created.  Check the following on AWS console:

1. A loadbalancer has been created. You may also see the DNS of loadbalancer with following
    ```
    kubectl -n ingress-nginx get svc
    ```
1. Edit listner 443 settings.  Select TLS. 
1. Set target group of 443 listener to one which listner 80 points.  Basically, we want TLS termination at the LB and it must forward HTTP traffic (not HTTPS) to port 80 of ingress controller.  So 

    * input of LB = 443 (HTTPS)
    * out of LB = HTTP --> port 80 of ingress nginx controller
1. Make sure in the target group settings Proxy Protocol v2 is enabled.
1. Make sure health check of target groups is working fine.

## Doman name
* Create a domain name for your rancher like `rancher.mosip.net` and point it to **internal** ip address of the LB.  Thi assumes that you have a wireguard to receive traffic from Internet and point to internal LB. 

## Rancher
* Install rancher using Helm.
    ```
     helm install rancher rancher-latest/rancher \
      --namespace cattle-system \
      --set hostname=rancher.mosip.net \
      --set bootstrapPassword=admin \
      --set tls=external
    ```
## Login 
* Open rancher page `https://rancher.mosip.net`
* Get Bootstrap password using
    ```
    kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{ .data.bootstrapPassword|base64decode}}{{ "\n" }}'
    ```
* Assign a password.  IMPORTANT: makes sure this password is securely saved and retrievable by Admin.

## Keycloak integration
