# Rancher Management Server

## Introduction
Rancher may be used to manage all your clusters.  Typically, you would need just one installation per organisation.
Install Rancher before you install MOSIP cluster.  While Rancher may be installed native, or just using Docker on any VM, for high availability and management we recommend installing on a Kubernetes cluster. You may also use the same cluster to install IAM [Keycloak](https://www.keycloak.org/).  Here, we provide instructions to install Rancher Management Server along with Keycloak within the same cluster.  

## On-prem 
* Create a dedicated k8s cluster. You would need at least 2 worker nodes for high availability. Create cluster on AWS as given [here](aws/README.md).  For on-prem clusters you will have to follow cluster installation as given [here](on-prem/README.md)
* Follow the instructions given [here](https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/) for Rancher related prerequisites.
* For external access you will need a public domain like `rancher.xyz.net` to point to this installation.
* A reference architecture which integrates rancher and IAM in same cluster is depicted as follows:
![](../docs/images/rancher_iam.png)  
* TLS termination: you may terminate TLS in any of the following ways:
  * Directly on Rancher service
  * On ingress controller
  * On a reverse proxy before the ingress controller

* Run below command to install all Rancher with tls termination on rancher itself, using letsencrypt certs:
    ```
    helm install rancher rancher-latest/rancher  --namespace cattle-system  --set hostname=<your-rancher-domain> --set ingress.tls.source=letsEncrypt  --set letsEncrypt.email=info@mosip.io --set replicas=2
    ```
* Set replicas in above command to number of nodes in your Rancher cluster or higher.

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
1. Make sure all subnets are selected in LB -->Description --> Edit subnets.

## Doman name
* Create a domain name for your rancher like `rancher.mosip.net` and point it to **internal** ip address of the LB.  Thi assumes that you have a wireguard to receive traffic from Internet and point to internal LB. 

## Keycloak
We recommend using an IAM that controls user access to the cluster.  Here, we install Keycloak in the same cluster.

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



## IAM integration
* Enabled authentication with Keycloak using the steps given [here](https://rancher.com/docs/rancher/v2.5/en/admin-settings/authentication/keycloak/).
* IMPORTANT: If you have logged in as admin user in Keycloak make sure an email id, and first name field is added to the admin user of Keycloak before you try to authenticate with Rancher.
* In Keyclok add another Mapper for the rancher client (in Master realm) with following fields:
  * Protocol: saml
  * Name: username
  * Mapper Type: User Property
  * Property: username
  * Friendly Name: username
  * SAML Attribute Name: username
  * SAML Attribute NameFormat: Basic

* Specify the following mappings in Rancher's Authentication Keycloak form:
  * Display Name Field: givenName
  * User Name Field: email
  * UID Field: username
  * Entity ID Field: https://your-rancher-domain/v1-saml/keycloak/saml/metadata
  * Rancher API Host: https://your-rancher-domain
  * Groups Field: member
* For users in keycloak assign roles rancher - cluster and project roles.  Under `default` project add all the namespaces. Then, for a non-admin user you may provide Read-Only role (under projects).
* Add a member to cluster/project in Rancher:
  * Give member name exactly as `username` in Keycloak
  * Assign appropriate role like Cluster Owner, Cluster Viewer e
