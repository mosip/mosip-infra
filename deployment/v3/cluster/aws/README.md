# MOSIP cluster on Amazon EKS

## Create using eksctl
* If you already have `~/.kube/config` file created for another cluster, rename it.
* Install `eksctl` as given [here](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
* Install `kubectl`
* Set AWS credentials in `~/.aws/` folder (refer AWS documentation)
* Review cluster params in `create.sh`, then run the script.
* Note that it takes around 30 minutes to create (or delete a cluster).
* After creating cluster make a copy of `config` with a suitable name in `~/.kube/` folder, eg. `iam_config`, `mosip_config`.

## Create using Rancher
You can also create cluster on Cloud using the Rancher console.  Refer to Rancher documentation.

## Persistence
### AWS
* Default storage class is `gp2` which by is in "Delete" mode.  After helm is deleted, PV also gets deleted.  
* To retain define a storage class `gp2-retain` by running `sc.yaml`. This will retain the PV. You will have to delete the storage from AWS console.  See some more details on persistence [here](../../docs/persistence.md).
```
$ kubectl apply -f sc.yaml
```
* If the PV gets deleted (say cluster was retarted), then you will have to define a PV connecting to this instance of storage (you will need volume ID etc). TODO: how to do this?

## Ingress and load balancer (LB)
Ingress is not installed by default on EKS.  Note that we are not using ingress controller provided by AWS, but install our own controller.  Good discussion [here](https://itnext.io/kubernetes-ingress-controllers-how-to-choose-the-right-one-part-1-41d3554978d2). See also [this](https://blog.getambassador.io/configuring-kubernetes-ingress-on-aws-dont-make-these-mistakes-1a602e430e0a)  

### Install
* Install nginx ingress as per instructions given [here](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm). Specifically, 
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
$ kubectl create namespace ingress-nginx
$ helm -n ingress-nginx install ingress-nginx ingress-nginx/ingress-nginx -f ingress_values.yaml
```
* If you would like to have load balancer on internal ip (rather than internet-facing) set this in `ingress_values.yaml`:
```
      service.beta.kubernetes.io/aws-load-balancer-internal: "true"
```
Internal LB is needed when you would have a front-end landing server running wireguard which will connect to the internal LB thereby avoid public access to your installation.  See section on [wireguard](## Wireguard bastion host)

### Posgtres external access
* If you have installed postgres inside the cluster, the same may be accessed from outside if you have enabled port 5432 TCP listner on LB and set the following configuration in `ingress_values.yaml`:
```
tcp: 
  5432: "postgres/postgresql:5432"
```
* To enable access later in case you didn't do it while creating ingress apply the following configmap and restart nginx ingress controller pod:
```
kubectl apply -f tcp_configmap.yaml
```

### Network Load Balancer
* AWS will assign a Network Load Balancer (Layer 4) that can be seen as:
```
$ kubectl -n ingress-nginx get svc
```
* TLS termination is supposed to be on LB.  So all our traffic coming to ingress controller shall be HTTP.
* Note that we are not using ingress controller provided by AWS, but installing nginx ingress controller] as above.  Good discussion [here](https://itnext.io/kubernetes-ingress-controllers-how-to-choose-the-right-one-part-1-41d3554978d2). See also [this](https://blog.getambassador.io/configuring-kubernetes-ingress-on-aws-dont-make-these-mistakes-1a602e430e0a)  
* Obtain AWS TLS certificate as given [here](https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html) 
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
$ kubectl apply -f ../global_configmap.yaml
```
## Wireguard bastion host
If you do not want public access to your installation, you may set up a bastion host running Wireguard as shown below:
![](../../docs/images/wireguard_landing.jpg)

Follow the procedure given [here](../../docs/wireguard.md)

## Log rotation
The default log max log file size set on EKS cluster is 10MB with max number of files as 10.  Refer to `/etc/docker/daemon.json` on any node. 

## Cluster management
Import cluster into Rancher and assign access rights users in IAM (Keycloak)

## Monitoring
Enable Prometheus in Rancher (via Rancher Apps). 

