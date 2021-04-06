# MOSIP cluster on Amazon EKS

## Create
* If you already have `~/.kube/config` file created for another cluster, rename it.
* Install `eksctl` as given [here](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
* Install `kubectl`
* Set AWS credentials in `~/.aws/` folder (refer AWS documentation)
* Review cluster params in `create.sh`, then run the script.

## Persistence
### AWS
* Default storage class is `gp2`.  
* To persist define another storage class with `Retain` policy.
* If the PV gets deleted (say cluster was retarted), then you will have to define a PV connecting to this instance of storage (you will need volume ID etc). TODO: how to do this?

## Ingress and load balancer (LB)
Ingress is not installed by default on EKS.  Note that we are not using ingress controller provided by AWS, but install our own controller.  Good discussion [here](https://itnext.io/kubernetes-ingress-controllers-how-to-choose-the-right-one-part-1-41d3554978d2). See also [this](https://blog.getambassador.io/configuring-kubernetes-ingress-on-aws-dont-make-these-mistakes-1a602e430e0a)  

### Install
* Install nginx ingress as per instructions given [here](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/#). Specifically, 
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
$ kubectl create namespace ingress-nginx
$ helm -n ingress-nginx install ingress-nginx ingress-nginx/nginx-ingress -f ingress_values.yaml
```
* If you would like to have load balancer on internal ip (rather than internet-facing) set this in `ingress_values.yaml`:
```
      service.beta.kubernetes.io/aws-load-balancer-internal: "true"
```

### Posgtres external access
* Apply the nginx transport server.  This is required only if postgres is installed within the cluster and requires external access. 
```
$ kubectl apply -f transportserver.yaml
```
### Network Load Balancer
* AWS will assign a Network Load Balancer (Layer 4) that can be seen as:
```
$ kubectl -n ingress-nginx get svc
```
* TLS termination is supposed to be on LB.  So all our traffic coming to ingress controller shall be HTTP.
* Note that we are not using ingress controller provided by AWS, but installing nginx ingress controller] as above.  Good discussion [here](https://itnext.io/kubernetes-ingress-controllers-how-to-choose-the-right-one-part-1-41d3554978d2). See also [this](https://blog.getambassador.io/configuring-kubernetes-ingress-on-aws-dont-make-these-mistakes-1a602e430e0a)  
* Obtain AWS certificate as given [here](https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html) 
* Add the certificates and 443 access to the LB listener.
  * Update listener TCP->443 to **TLS->443** and point to the certificate of domain name that belongs to your cluster.
* Forward TLS->443 listner traffic to target group that corresponds to lisner on port 80. This is because after TLS termination the protocol is HTTP so we must point LB to HTTP port of ingress controller.
* Set proxy protocol in LB targets. Without setting this your Keycloak will return "http://.." URLs instead of "https:// .."
  * Go to AWS "Target Groups" tabs
  * You should see one of your instances pointing to LB. Select the instance.
  * Scroll down to edit Attributes.  Enable "Proxy Protocol v2".

The reason for considering a LB for ingress is such that TLS termination can happen at the LB and packets can be inspected before sending to cluster ingress.  Thus ingress will receive plain text. On EKS, we will assume that the connection between Loadbalancer and cluster machines is secure (Wireguard cannot be installed on LB).

NOTE: if you make any change in the ingress service, you will have to delete it completely and re-install.  'Hot' changes may not reflect in LB. This will also give a new load balancer ip.

### Domain name
* Point your domain name to LB's public DNS/IP. 
* On AWS this may be done on Route 53 console.  You will have to add a CNAME record if your LB has public DNS or an A record if IP address.
* Update the domain name in `global_configmap.yaml` and run
```
$ kubectl apply -f global_configmap.yaml
```

## Notes
Current ingress controller has a work around described [here](https://github.com/nginxinc/kubernetes-ingress/issues/1250).  The config map implements the work around.  We have added another snipped to makes sure port 443 is forwarded to upstream server as X-FORWARDED-PORT.  Note that this will **not work** if original request is `http` and not `https`.  
```
proxy_set_header X-Forwarded-Port {{if $server.RedirectToHTTPS}}443{{end}}; 
```
