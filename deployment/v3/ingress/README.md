# Ingress controller

## AWS
* Install nginx ingress as
```
$ kubectl create namespace nginx-ingress
$ helm -n nginx-ingress install nginx-ingress bitnami/nginx-ingress-controller -f values.yaml
```
* AWS will assign a Loadbalancer that can be seen as:
```
$ kubectl -n nginx-ingress get svc
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

## Bare-metal
* We must install MetallB and expose ingress controller with LoadBalancer service type
* Have an external Nginx that will terminate HTTPS and pass on HTTP to cluster via ingress.
