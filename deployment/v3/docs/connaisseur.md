## Connaisseur
Connaisseur is implemented as an admission controller, which means after a resource that is to be deployed to a cluster has gone through the authentication and authorization steps, it will be verified by Connaisseur before actually hitting the cluster.

### Why we need Connaisseur !
In open world of Kubernetes and docker, we pull images from open source dockers (e.g Dockerhub). When pulling these images, how can you be sure of their contents? Are there no malicious services hidden in there somewhere? To solve this problem, `Docker Content Trust(DCT)` was introduced by Docker community to ensure security using `signed dockers`. But, activating this feature in the `Docker daemon` of Kubernetes doesn’t prevent you from pulling/deploying unsigned images.  
There we need Connaisseur which is used to verify the signatures of images.

### How it works
Connaisseur acts as a Kubernetes Mutating Admission Webhook that intercepts requests to the cluster and ensures that the `image:tag` included in a deployment request is transformed into a trusted and cryptographically verified `image@digest` with its unaltered content. The trusted image digest is then used for starting containers in the Kubernetes cluster.  For more details, [see](https://github.com/sse-secure-systems/connaisseur#how-it-works). 

![ ](https://github.com/sse-secure-systems/connaisseur/blob/master/img/connaisseur_overview.png)

### Algorithm
```
- Connaisseur searches for all image references in the resource.
- Connaisseur collects them in a list.
- For each image in the list:
	- Connaisseur will look up the manifest files in a `notary` instance.
	- Validate their signatures:
		- if valid signature:
			- the corresponding digest for the tag is extracted.
			- the original image reference is changed to use the digest insteasd of the tag.
		- if not valid signature || image is not present in manifest || manifest file is not there:
			- deny the resources.
			- stop it's deployment completely.
```
If we want to deploy an image, Connaisseur will only deploy the signed version or none at all.

### How to enable
- Install prerequisite packages : git, docker, kubectl , make, openssl, yq, and helm.
- Clone the official git repo provided by SSE:
	```
	$ git clone https://github.com/sse-secure-systems/connaisseur.git
	$ cd connaisseur/
	```
- Modify the `helm/values.yaml` file for following sections:
	1. Enable or disable authentication:
		```
		auth:
		  enabled: (true/false)
		```
	 2.    `notary.host` field specifies the hostname and port of the Notary server. If your Notary uses a self-signed certificate, `notary.selfsigned` should be set to `true` and the certificate has to be added to `notary.selfsignedCert`. In case your Notary instance is authenticated (which it should), set the `notary.auth.enabled` to `true` and enter the credentials either directly or as a predefined secret. Lastly enter the public root key in `notary.rootPubKey`, which is used for verifying the image signatures.
- Run the following command to install helm chart along with configurations:
	```
	$ make install  
	$ kubectl get all -n <namespace>
	```
-   Trying to deploy an unsigned app to your cluster will be denied due to lack of trust data. For example-
	```
	$ kubectl run unsigned --image=docker.io/securesystemsengineering/testimage:unsigned
	```
-  However, the signature of signed image will be successfully verified.
For example-
	```
	$ kubectl run signed --image=docker.io/securesystemsengineering/testimage:signed
	```
-   You can compare the trust data of the two images via command:
	```
	$ docker trust inspect --pretty docker.io/securesystemsengineering/testimage
	```
-   To uninstall Connaisseur from your cluster, run the following command:
	```
	$ make uninstall
	```
