## 1. Setting up kubernetes with rke on Ubuntu

- Exchange keys with the remote node:
  - First generate keys on our machine:
  ```
  $ ssh-keygen -t rsa
  ```
  - Then copy the keys to the node.
  ```
  $ ssh-copy-id <remote-user>@<remote-ip>
  ```
  - Then test by directly ssh into the node. It should ask password this time.
  <details>
    <summary>But when there is no access to the remote without your private key</summary>

    ```
    $ scp -i <your-private-key> ~/.ssh/id_rsa.pub <remote-user>@<remote-ip>:/tmp/
    $ ssh -i <your-private-key> <remote-user>@<remote-ip>
    <remote-user>@<remote-ip>$ cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys
    <remote-user>@<remote-ip>$ exit
    $ ssh <remote-user>@<remote-ip>
    ```
  </details>

- Install docker on the remote node. Using the following command or [this](https://docs.docker.com/engine/install/ubuntu/).
  - `sudo apt install docker.io`
  - Be sure to add user to docker group.<br/>
  `sudo usermod -aG docker $USER`
  - Exit and ssh again. Check if docker is accessible without sudo.<br/>
  `docker stats`
- Configure rke cluster. `rke config`.
  - Number of hosts is the number of nodes.
  - Internal IP is; if we want the nodes to talk to eachother on a different interface, other than their ssh/public ip.
  - Any combination of `controlplane, etcd, worker` roles can be used for any nodes.
  - Use default Canal networking model
  - Keep the Pod Security Policies disabled.

    <details>
      <summary>Sample Config Options</summary>

      ```
      [+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]:
      [+] Number of Hosts [1]:
      [+] SSH Address of host (1) [none]: <node1-ip>
      [+] SSH Port of host (1) [22]:
      [+] SSH Private Key Path of host (<node1-ip>) [none]:
      [-] You have entered empty SSH key path, trying fetch from SSH key parameter
      [+] SSH Private Key of host (<node1-ip>) [none]:
      [-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
      [+] SSH User of host (<node1-ip>) [ubuntu]:
      [+] Is host (<node1-ip>) a Control Plane host (y/n)? [y]: y
      [+] Is host (<node1-ip>) a Worker host (y/n)? [n]: y
      [+] Is host (<node1-ip>) an etcd host (y/n)? [n]: y
      [+] Override Hostname of host (<node1-ip>) [none]: node2
      [+] Internal IP of host (<node1-ip>) [none]:
      [+] Docker socket path on host (<node1-ip>) [/var/run/docker.sock]:
      [+] Network Plugin Type (flannel, calico, weave, canal) [canal]:
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
    </details><br/>
  - After the above command edit any other changes to `cluster.yml` in current folder.
  - If you dont want the default ingress controller installed (default is not recommended), edit `ingress` section of the `cluster.yml`.
    ```
    ingress:
      provider: none
    ```
  - Also edit the following section in `cluster.yml`, this is required for CSRs to get issued (which is required for minio operator install)
    ```
    services:
      kube-controller:
        extra_args:
          cluster-signing-cert-file: "/etc/kubernetes/ssl/kube-ca.pem"
          cluster-signing-key-file: "/etc/kubernetes/ssl/kube-ca-key.pem"
    ```
- Bring up the cluster, with the given cluster.yml: `rke up`
- Once `rke up` is done, cluster is setup. Yayy. It will give a `kube_config_cluster.yaml`. Copy that into your `$HOME/.kube/` directory and set proper permissions.
  ```
  cp kube_config_cluster.yml ~/.kube/cluster_name.config
  chmod 600 ~/.kube/cluster_name.config
  ```
- Then add the above kubeconfig file to environment variable `KUBECONFIG`. Or create aliases in `~/.bashrc` or equivalent, like
  ```
  alias kc='KUBECONFIG="$HOME/.kube/cluster_name.config" kubectl'
  ```
- Try if kubectl is actually working. `kc get nodes`

## 2. Adding nodes to cluster.

* Copy the ssh keys to the new nodes.
  ```
  ssh-copy-id <user>@<new-node-ip>
  ```
* Install docker on all the new nodes.
  ```
  sudo apt install docker.io
  sudo usermod -aG $USER docker
  ```
* Double check that the ssh and docker both dont ask for passwords when running.
* Navigate to the same folder as above, where the `cluster.yml` and `cluster.rkestate` files are located.
* Edit the cluster.yml file
  * Add extra nodes with their ips and roles.
* `rke up --update-only` to bring up the changes to the cluster.
* Once this is done the changes should reflect in the cluster.
```
kubectl get nodes
```
