## Steps to install on Ubuntu Server

1. Create `mosip` user on rancher node with password-less sudo.
1. Do the same on console machine which is running Ubuntu Server.
1. Exchange keys with Rancher nodes.  Make sure .ssh directory and rsa key permissions are correct.
1. Add `mosip` user to docker group on Rancher nodes:
    ```
    $ sudo adduser mosip docker
    ```
1. Open 6443 on rancher nodes.
1. Make sure you are running all the below commands as `mosip` user.
1. Install net-tools
    ```
    $ sudo apt install net-tools
    ```
1. Run `./rke config`
    ```
    mosip@ip-172-31-10-25:~/downloads$ ./rke config                                                                         
    [+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]:                                                                 
    [+] Number of Hosts [1]:                                                                                                
    [+] SSH Address of host (1) [none]: 172.31.43.69                                                                        
    [+] SSH Port of host (1) [22]:                                                                                          
    [+] SSH Private Key Path of host (172.31.43.69) [none]:                                                                 
    [-] You have entered empty SSH key path, trying fetch from SSH key parameter                                            
    [+] SSH Private Key of host (172.31.43.69) [none]:                                                                      
    [-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa                                  
    [+] SSH User of host (172.31.43.69) [ubuntu]: mosip                                                                     
    [+] Is host (172.31.43.69) a Control Plane host (y/n)? [y]: y                                                           
    [+] Is host (172.31.43.69) a Worker host (y/n)? [n]: y
    [+] Is host (172.31.43.69) an etcd host (y/n)? [n]: y
    [+] Override Hostname of host (172.31.43.69) [none]: node1
    [+] Internal IP of host (172.31.43.69) [none]: 172.31.43.69
    [+] Docker socket path on host (172.31.43.69) [/var/run/docker.sock]: 
    [+] Network Plugin Type (flannel, calico, weave, canal) [canal]: flannel
    [+] Authentication Strategy [x509]: 
    [+] Authorization Mode (rbac, none) [rbac]: 
    [+] Kubernetes Docker image [rancher/hyperkube:v1.17.17-rancher1]: 
    [+] Cluster domain [cluster.local]: 
    [+] Service Cluster IP Range [10.43.0.0/16]: 
    [+] Enable PodSecurityPolicy [n]: 
    [+] Cluster Network CIDR [10.42.0.0/16]: 
    [+] Cluster DNS Service IP [10.43.0.10]: 
    [+] Add addon manifest URLs or YAML files [no]: 
    ```   
1. Install docker. (No need to reboot console)
    ```
    $ sudo addgroup --system docker
    $ sudo adduser $USER docker
    $ newgrp docker
    $ sudo snap install docker
    ```

1. Install rancher server:
    ```
    docker run -d --privileged  -p 80:80 -p 443:443 rancher/rancher:latest
    ```
1. http://console_ip.   password: ad67
1. Install `kubectl`
    ```
    $ sudo snap install kubectl --classic
    ```
1. Copy kubeconfig file:
    ```
    $ mkdir ~/.kube
    $ cp kube_config_cluster.yml ~/.kube/config

1. Install helm
    ```
    https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz
    ```
1. Ingress is automatically installed as daemonset and bound to port 80 and 443.  Read here:
https://kubernetes.github.io/ingress-nginx/deploy/baremetal/#via-the-host-network
Ingress runs as a daemonset on all nodes.

1. TODO: if ingress runs as nodeport, and if one worker is down, how does external nginx switch to another?

1. Set up rancher server for [external TLS termination](https://rancher.com/docs/rancher/v2.x/en/installation/install-rancher-on-k8s/chart-options/#external-tls-termination).  Mention public domain name of your cluster node machine:
```
helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=<node public domain name> --set tls=external
```
Then access the rancher UI on your browser with
```
http://<node public domain name>
```
