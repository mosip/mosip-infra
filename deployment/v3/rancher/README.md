# Rancher Management Server

## Introduction
Rancher may be used to manage all your clusters.  Typically, you would need just one installation per organisation.
Install Rancher before you install MOSIP cluster.  While Rancher may be installed native, or just using Docker on any VM, for high availability and management we recommend installing on a Kubernetes cluster. You may also use the same cluster to install [IAM](../external/iam/README.md)  Here, we provide instructions for running Rancher on a k8s cluster.

## Rancher install on k8s
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
