# Upgrade Kubernetes cluster version from 1.19.x to 1.21.1

* Install a specific version of Kubernetes packages on the console, master & worker nodes.
  ```
  ## on master
    yum install kubectl-1.21.1 kubeadm-1.21.1 kubelet-1.21.1 -y
    systemctl daemon-reload
    systemctl restart kubelet
  
  ## on workers
    yum install kubectl-1.21.1 kubeadm-1.21.1 kubelet-1.21.1 -y
    systemctl daemon-reload
    systemctl restart kubelet
  ```

* On master, after installing upgraded packages
  ```
  sudo kubeadm upgrade node
  ```