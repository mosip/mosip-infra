# MOSIP cluster on Amazon EKS

## Create
* Run `create.sh` script to create a cluster.

## Persistence
### AWS
* Default storage class is `gp2`.  
* To persist define another storage class with `Retain` policy.
* If the PV gets deleted (say cluster was retarted), then you will have to define a PV connecting to this instance of storage (you will need volume ID etc). TODO: how to do this?

## Ingress and Loadbalancer
Ingress is not installed by default on EKS.

* Install nginx ingress as per instructions given [here](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/#). 
```
$ helm repo add nginx-stable https://helm.nginx.com/stable
$ helm repo update
$ kubectl create namespace ingress-nginx
$ helm -n ingress-nginx install nginx-stable/nginx-ingress -f ingress_values.yaml
```
* Apply the nginx transport server.  This is required for exposing postgres. You may skip this if postgres is not be accessed from outside the cluster.
```
$ kubectl apply -f transportserver.yaml
```
* AWS will assign a Loadbalancer that can be seen as:
```
$ kubectl -n ingress-nginx get svc
```
* TLS termination is supposed to be on Loadbalancer.  So all our traffic coming to ingress controller shall be HTTP.
* Note that we are not using ingress controller provided by AWS, but installing nginx ingress controller] as above.  Good discussion [here](https://itnext.io/kubernetes-ingress-controllers-how-to-choose-the-right-one-part-1-41d3554978d2). See also [this](https://blog.getambassador.io/configuring-kubernetes-ingress-on-aws-dont-make-these-mistakes-1a602e430e0a)  
* Obtain AWS certificate as given [here](https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html) 
* Add the certificates and 443 access to the Loadbalancer listener.
  * Delete the existing listeners
  * Create a new one with TLS 443 and point to the certificate of domain name that belongs to your cluster.
* Note `use-proxy-protocol = "true"` in controller configmap. Correspondingly, you have to set proxy protocol in Loadbalancer targets as well. Without setting this your Keycloak will return "http://.." URLs instead of "https:// .."
  * Go to AWS "Target Groups" tabs
  * You should see one of your instances pointing to LoadBalancer. Select the instance.
  * Scroll down to edit Attributes.  Enable "Proxy Protocol v2".

The reason for considering a Loadbalancer for ingress is such that TLS termination can happen on the Loadbalancer and packets can be inspected before sending to cluster ingress.  Thus ingress will receive plain text. On EKS, we will assume that the connection between Loadbalancer and cluster machines is secure (Wireguard cannot be installed, it does not work on Cloud). 

