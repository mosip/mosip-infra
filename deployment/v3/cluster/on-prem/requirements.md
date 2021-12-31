# Requirements for On-prem Nodes/VMs

* We need atleast the following no of nodes with atleast the following specifications to meet the prerequisites.
  * 5 nodes each with specs: 8 cores, 32 GB RAM, 64 GB Disk. Mosip cluster will be setup on these nodes.
  * 2 nodes each with specs: 2 cores, 8 GB RAM, 64 GB Disk. Rancher + IAM cluster will be setup in 2 of these nodes.
  * 1 node, same as above, with specs: 2 cores, 8 GB RAM, 64 GB Disk. Nginx will be setup in this node.
  * Note: Wireguard bastion will also be setup on the nginx node only, no need for a dedicated VM.
* The Nginx node should be accessible publicly. That means, this node should have atleast the following networking configuration:
  * One internal network interface where it can talk to the other nodes, one public interface
  * One public interface; this either has a direct public ip. Or there is some firewall rule somewhere else to forward that public-ip 443/tcp & 51820/udp traffic to this interface. (51820 is wireguard port, for bastion server).
  * Side note: If wireguard bastion is to be installed on the same node as the nginx, One may omit the dedicated internal interface. This is only required to distinguish internal vs public traffic coming to nginx node. In this case we can replace the internal interface with this wiregaurd interface only. Even the DNS (for internal hostnames) can point to this.
* DNS info:
  * All the publicly accessible hostname should be mapped to the public ip of nginx node.
  * All the internal/non-public hostnames should be mapped to the internal interface of nginx node
  * For a full list of public vs internally accessible hostname, refer to [this](../global_configmap.yaml.sample)
  * Rancher and IAM hostname can also be mapped to the internal interface ip. (Unless they want to be publicly accessible, then they can be mapped to public ip).
* For the SSL certificates:
  * One wildcard certificate like `*.mosip.xyz.net` is sufficient for all the hostnames if they are decided to be put under the same hostname. Like;
  * Since the certificates go only one level in hierarchy, something like `prereg.sandbox1.mosip.xyz.net`, would work because a new certiificate will be required here.
  * So choose the hostnames and certificates accordingly, before getting started. Refer [here](../global_configmap.yaml.sample) again for a list of hostname required by mosip (*Excluding Rancher and IAM hostnames*)
