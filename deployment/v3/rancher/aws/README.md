# AWS EKS Cluster for Rancher

## Prerequisites
* Wireguard is setup as given [here](../docs/wireguard_bastion.md)
* If you already have `~/.kube/config` file created for another cluster, rename it.
* Install k8s cluster using `eksctl` as given [here](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
* Set AWS credentials in `~/.aws/` folder as given [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
* Install `kubectl`
* Make sure you have keys to created EC2 instance in `~/.ssh/`. If not, generate a key pair using AWS console.
* Ensure to have aws-iam-authenticator there as given [here](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)

## Install cluster
* Copy `rancher.cluster.config.sample ` to `rancher.cluster.config`.  
* Review the parameters of `rancher.cluster.config` carefully.
* Install
```sh
eksctl create cluster -f cluster.config
```
* Note that it takes around 30 minutes to create (or delete a cluster).
* After creating cluster make a backup copy of `config` with a suitable name in `~/.kube/` folder, eg. `rancher_config` because if you create cluster again using `eksctl` it will override existing `~/.kube/config`. Set file permission to `chmod 400 ~/.kube/rancher_config`` to avoid any accidental changes or deletion.

## Nginx ingress
```
helm install \                               
  ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --version 3.12.0 \
  --create-namespace  \
-f nginx.values.yaml
```

### Set configmap 
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
## AWS Loadbalancer (LB)
The `nginx.values.yaml` specifies a AWS Network Loadbalancer (L4) be automatically created.  Check the following on AWS console:

1. An LB has been created. You may also see the DNS of LB with
    ```
    kubectl -n ingress-nginx get svc
    ```
1. Edit listner "443".  Select "TLS". 
1. Note the target group name of listner 80. Set target group of 443 to target group of 80.  Basically, we want TLS termination at the LB and it must forward HTTP traffic (not HTTPS) to port 80 of ingress controller.  So 
    * Input of LB:  HTTPS
    * Output of LB: HTTP --> port 80 of ingress nginx controller
1. Enable "Proxy Protocol v2" in the target group settings 
1. Make sure all subnets are selected in LB -->Description-->Edit subnets.
1. Check health check of target groups.
1. Remove listner 80 from LB as we will receive traffic only on 443.

## Domain name
Create a domain name for your rancher like `rancher.mosip.net` and point it to **internal** ip address of the LB. This assumes that you have a wireguard to receive traffic from Internet and point to internal LB. 
