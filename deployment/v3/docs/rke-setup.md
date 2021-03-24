## Setting up kubernetes with rke on Ubuntu

- Exchange keys with the remote node:
  - First generate keys on our machine:
  ```
  $ ssh-keygen -t rsa
  ```
  - Then copy the keys to the node. `ssh-copy-id` can be used directly. But when there is no access to the remote without your private key:
  ```
  $ scp -i <your-private-key> ~/.ssh/id_rsa.pub <remote-user>@<remote-ip>:/tmp/
  $ ssh -i <your-private-key> <remote-user>@<remote-ip>
  <remote-user>@<remote-ip>$ cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys
  <remote-user>@<remote-ip>$ exit
  $ ssh <remote-user>@<remote-ip>
  ```
- Install docker on the remote node. Using [this](https://docs.docker.com/engine/install/ubuntu/).
  - Make sure to install docker version <= 19.03.xx, because with rke, the docker version should be less than so.
  ```
  $ sudo apt-get install net-tools
  $ sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release
  $ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  $ echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  $ sudo apt-get update
  $ apt-cache madison docker-ce
  $ sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io
  ```
  - Or simply install using snap `sudo snap install docker`. Check version before installing.
- Be sure to add user to docker group.
  - `$ sudo usermod -aG docker $USER`
  - or, `sudo adduser $USER docker`
- Configure rke cluster-config.
  - `rke config`
  ```
  [+] Cluster Level SSH Private Key Path [~/.ssh/id_rsa]:
  [+] Number of Hosts [1]:
  [+] SSH Address of host (1) [none]: 13.235.57.204 <your-node-ip-here>
  [+] SSH Port of host (1) [22]:
  [+] SSH Private Key Path of host (13.235.57.204) [none]:
  [-] You have entered empty SSH key path, trying fetch from SSH key parameter
  [+] SSH Private Key of host (13.235.57.204) [none]:
  [-] You have entered empty SSH key, defaulting to cluster level SSH key: ~/.ssh/id_rsa
  [+] SSH User of host (13.235.57.204) [ubuntu]:
  [+] Is host (13.235.57.204) a Control Plane host (y/n)? [y]: y
  [+] Is host (13.235.57.204) a Worker host (y/n)? [n]: y
  [+] Is host (13.235.57.204) an etcd host (y/n)? [n]: y
  [+] Override Hostname of host (13.235.57.204) [none]: node2
  [+] Internal IP of host (13.235.57.204) [none]:
  [+] Docker socket path on host (13.235.57.204) [/var/run/docker.sock]:
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
- Bring up the cluster: `rke up`
- Copy the kube-config file and set proper permissions.
  - `$ cp kube_config_cluster.yml ~/.kube/config`
  - `$ chmod 600 ~/.kube/config`
- Try if kubectl is actually working. `$ kubectl get nodes`
- Install rancher. Recommended to install from the helm chart.
  - Add rancher helm repo `helm repo add rancher-latest https://releases.rancher.com/server-charts/latest`
  - Install rancher in cattle-system namespace.
  ```
  $ kubectl create ns cattle-system
  $ helm install rancher rancher-latest/rancher --namespace cattle-system --set hostname=<node public domain name> --set tls=external
  ```
- Wait for a few minutes and access the rancher dashbaord from your browser.
