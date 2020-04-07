# Clone the code

# Generate ssh key
For better access generate ssh keys in ansible controller and copy to all the machines and copy it to the root user.
    
    Example: Copy to all machines to all but I am giving you below example. 
    
      ssh-keygen -t rsa 
      ssh-copy-id root@<kubernetes-master-ip>
      ssh-copy-id root@<kubernetes-node-ip> 
      ssh-keygen -t rsa 
      
# Kubeadm Ansible Playbook

Build a Kubernetes cluster using Ansible with kubeadm. The goal is easily install a Kubernetes cluster on machines running:
  - CentOS 7

System requirements:

  - Deployment environment must have Ansible `2.4.0+`
  - Master and nodes must have passwordless SSH access

# Usage

Add the system information gathered above into a file called `hosts.ini`. For example:
```
[master]
192.16.35.12

[node]
192.16.35.[10:11]

[kube-cluster:children]
master
node
```
Before continuing, edit `group_vars/all.yml` to your specified configuration.

For example, I choose to run `flannel` instead of calico, and thus:

```yaml
# Network implementation('flannel', 'calico')
network: flannel
```

**Note:** Depending on your setup, you may need to modify `cni_opts` to an available network interface. By default, `kubeadm-ansible` uses `eth1`. Your default interface may be `eth0`.

# Metallb Changes

Reserver the ip address for loadbalancer at the below var folder

        roles/metallb/var/main.yml
        
change the variable metallb_address_space: 192.168.205.200-192.168.205.210 according to your VMs subnet.

After going through the setup, run the `site.yaml` playbook:

```sh
$ ansible-playbook site.yaml
...
==> master1: TASK [addon : Create Kubernetes dashboard deployment] **************************
==> master1: changed: [192.16.35.12 -> 192.16.35.12]
==> master1:
==> master1: PLAY RECAP *********************************************************************
==> master1: 192.16.35.10               : ok=18   changed=14   unreachable=0    failed=0
==> master1: 192.16.35.11               : ok=18   changed=14   unreachable=0    failed=0
==> master1: 192.16.35.12               : ok=34   changed=29   unreachable=0    failed=0
```

The playbook will download `/etc/kubernetes/admin.conf` file to `$HOME/admin.conf`.

If it doesn't work download the `admin.conf` from the master node:

```sh
$ scp k8s@k8s-master:/etc/kubernetes/admin.conf .
```

Verify cluster is fully running using kubectl:

```sh

$ export KUBECONFIG=~/admin.conf
$ kubectl get node
NAME      STATUS    AGE       VERSION
master1   Ready     22m       v1.18.0
node1     Ready     20m       v1.18.0
node2     Ready     20m       v1.18.0

$ kubectl get po -n kube-system
NAME                                    READY     STATUS    RESTARTS   AGE
etcd-master1                            1/1       Running   0          23m
...
```

# Resetting the environment

Finally, reset all kubeadm installed state using `reset-site.yaml` playbook:

```sh
$ ansible-playbook reset-site.yaml
```

# Additional features
These are features that you could want to install to make your life easier.

Enable/disable these features in `group_vars/all.yml` (all disabled by default):
```
# Additional feature to install
additional_features:
  helm: false
  metallb: false
  healthcheck: false
```

## Helm
This will install helm in your cluster (https://helm.sh/) so you can deploy charts.

## MetalLB
This will install MetalLB (https://metallb.universe.tf/), very useful if you deploy the cluster locally and you need a load balancer to access the services.

## Healthcheck
This will install k8s-healthcheck (https://github.com/emrekenci/k8s-healthcheck), a small application to report cluster status.

# Utils
Collection of scripts/utilities

# Tips & Tricks
## Specify user for Ansible
If you use vms or your remote user is root, add this to `hosts.ini`(optional)
```
[master]
192.16.35.12 ansible_user='root'

[node]
192.16.35.[10:11] ansible_user='root'
```

