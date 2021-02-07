# Taints

Kubernetes provides *taints* feature to run a pod exclusively on a node. This is particularly useful during performance testing where you would like to allocate non-mosip components to separate nodes. 

By default, taints are not applied in the sandbox.  Provision to enable taints has been provided for the following modules:

* postgres
* minio
* hdfs

To enable taint set the following in `group_vars/all.yml`.  Example:
```
postgres:
  ...
  ...
  node_affinity: 
    enabled: true # To run postgres on an exclusive node
    node: 'mzworker0.sb' # Hostname. Run only on this node, and nothing else should run on this node
    taint:
      key: "postgres" # Key for applying taint on node
      value: "only"  
```
Here `node` is the machine on which you would like to run the module exclusively.

Make sure the above setting is done **before** you install the sandbox.

