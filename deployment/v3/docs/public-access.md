# Public Access

## Overview
* Initially till the complete MOSIP deployment and customization is in progress, by default all the dashboards and services are accessible only internally via internal LB.
* Also as per the requirement you can disable the public access.
 
## Steps to enable public access
* AWS
  * Edit the `istioOperator` using below command:
    ```
    kubectl edit istioOperator istio-operator-my -n istio-system
    ```
  * Enable the `istio-ingressgateway`:
    ```
    spec:
     components:
      ingressGateways:
      - enabled: **true**						# make this true
        k8s:
          serviceAnnotations:
            service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: '*'
            service.beta.kubernetes.io/aws-load-balancer-type: nlb
        name: istio-ingressgateway
    ```
  * Configure the public Loadbalancer created after enabling the same using [LB configuration guide](../cluster/aws/README.md#load-balancers).
  * Point all the publicly accessible domain names to the public LB DNS/IP.
  * Edit the prereg gateway to point to public LB.
    ```
    kubectl edit gateway prereg-gateway -n prereg
    ```
    as below
    ```
    spec:
      selector:
      istio: istio-ingressgateway			#update istio to point to public istioOperator
    ```
* On-prem
  * Update the server ip from `internal interface ip` to `external interface ip` in `upstream` section of `/etc/nginx/ngix.conf`
    ```
       upstream myPublicIngressUpstream {
         server <public interface ip>:30080;
    ```
  * Point all the publicly accessible domain names to the public interface ip.
