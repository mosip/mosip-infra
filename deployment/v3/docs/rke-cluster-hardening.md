# RKE Cluster Hardening Guide

This guide adds changes to the rke on premise deployment, such that they are compliant with the CMU security assessment report and CIS benchmark, also adds other minor changes.

For comprehensive document/guide, refer to rancher's documents on [CIS 1.6 benchmark](https://rancher.com/docs/rancher/v2.5/en/security/rancher-2.5/1.6-benchmark-2.5/) and [Hardening Guide](https://rancher.com/docs/rancher/v2.5/en/security/rancher-2.5/1.6-hardening-2.5/).

After running `rke config` and before bringing up the cluster with `rke up`, do the followin changes in cluster.yml in the respective sections:
- In kube-api-server section:
  ```
  services:
    kube-api:
      ...
      extra_args:
        kubelet-certificate-authority: "/etc/kubenetes/ssl/kube-ca.pem"
        profiling: false
      ...
      audit_log:
        enabled true
      ...
  ```
  - rke already has default values for audit_log_path, audit_log_maxage, audit_log_maxsize, audit_log_maxbackup, etc.
- In kube-controller section:
  ```
  services:
    kube-controller:
      ...
      extra_args:
        profiling: false
        cluster-signing-cert-file: "/etc/kubernetes/ssl/kube-ca.pem"
        cluster-signing-key-file: "/etc/kubernetes/ssl/kube-ca-key.pem"
      ...
  ```
- In kube-scheduler section:
  ```
  services:
    scheduler:
      ...
      extra_args:
        profiling: false
      ...
  ```
- In kubelet section:
  ```
  services:
    kubelet:
      ...
      extra_args:
        protect-kernel-defaults: true
      ...
  ```
  - Before making the above change, login to each of the cluster nodes and run the following lines:
    ```
    sudo echo -e  "vm.overcommit_memory=1\nvm.panic_on_oom=0\nkernel.panic=10\nkernel.panic_on_oops=1\nkernel.keys.root_maxbytes=25000000\n" > /etc/sysctl.d/90-kubelet.conf
    sudo sysctl -p /etc/sysctl.d/90-kubelet.conf
    ```
- In etcd section:
  ```
  services:
    etcd:
      ...
      gid: 52034
      uid: 52034
      ...
  ```
  - Before making the above change, login to each cluster node on which etcd is to be installed, and run the following:
    ```
    groupadd --gid 52034 etcd
    useradd --comment "etcd service account" --uid 52034 --gid 52034 etcd
    ```
- It is suggested to set this property,`automountServiceAccountToken: false`, on the 'default' `ServiceAccount` in ever namespace. Refer to this [Hardening Guide](https://rancher.com/docs/rancher/v2.5/en/security/rancher-2.5/1.6-hardening-2.5/) for further instructions.
- It is suggested to have `NetworkPolicy`s in every namespace, restricting access to services from only authorized services. Might not be relevant in mosip cluster, because of all the microservices at play accessing each other. Furthermore with istio service mesh in cluster, one can have fine rained access control. TODO.
- For `PodSecurityPolicy` setting, proper `PodSecurityPolicy`s have to be configured, refer to the [Hardening Guide](https://rancher.com/docs/rancher/v2.5/en/security/rancher-2.5/1.6-hardening-2.5/) again for an example configuration. Also with the rercent deprecation of the `PodSecurityPolicy` in newer versions of k8s and introduction of `Pod Security Admission` further study has to be done. Refer to [this](https://kubernetes.io/blog/2021/04/06/podsecuritypolicy-deprecation-past-present-and-future/). TODO.
