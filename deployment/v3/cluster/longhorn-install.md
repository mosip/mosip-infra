[Longhorn](https://longhorn.io) is a persistant storage provider / StorageClass. The following is how to install it. Installation procedure is same for both on-prem and aws clusters. Recommended to install it using Rancher (Refer [this](https://longhorn.io/docs/latest/deploy/install/install-with-rancher/)).

### Installing Longhorn
- (Optional)(Recommended) In rancher ui, create a new project, named "Storage". And create a namespace "longhorn-system" in that project.
- All the nodes in the cluster need to have these requirements: `bash, curl, findmnt, grep, awk, blkid, lsblk,` & iscsi & nfsv4 client.
  - To install open-iscsi, use the pre-provided daemonset.
  ```
  kubectl apply -n longhorn-system -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.1/deploy/prerequisite/longhorn-iscsi-installation.yaml
  ```
  - To install nfsv4 client, use the pre-provided daemonset.
  ```
  kubectl apply -n longhorn-system -f https://raw.githubusercontent.com/longhorn/longhorn/v1.1.1/deploy/prerequisite/longhorn-nfs-installation.yaml
  ```
  - These can also bee installed using apt-get/yum/zypper. See [this](https://longhorn.io/docs/latest/deploy/install/) for more details.
- Then go to Rancher-UI -> select desired cluster -> "Storage" Project -> Apps -> Launch -> search for Longhorn and install it.
- After installation, check `kubectl get storageclass`
- Longhorn Web-UI can be accessed with apps from rancher cluster dashboard (top-left of dashboard) -> longhorn.
- (Optional) If using istio, create a virtualservice to expose `longhorn-frontend` service with a gateway. Like,
  ```
  apiVersion: networking.istio.io/v1beta1
  kind: VirtualService
  metadata:
    name: longhorn
    namespace: longhorn-system
  spec:
    gateways:
    - istio-system/internal
    hosts:
    - '*'
    http:
    - headers:
        request:
          set:
            x-forwarded-proto: https
      match:
      - uri:
          prefix: /longhorn-ui/
      rewrite:
        uri: /
      route:
      - destination:
          host: longhorn-frontend
          port:
            number: 80

  ```

For some basic tests and, how to setup an s3 backupstore in Longhorn, refer [v3/docs/longhorn-backupstore-and-tests.md](../docs/longhorn-backupstore-and-tests.md).
