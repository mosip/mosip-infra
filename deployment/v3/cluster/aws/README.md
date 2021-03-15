# MOSIP cluster on Amazon EKS

## Create
* Run `create.sh` script to create a cluster.

## Persistence
### AWS
* Default storage class is `gp2`.  
* To persist define another storage class with `Retain` policy.
* If the PV gets deleted (say cluster was retarted), then you will have to define a PV connecting to this instance of storage (you will need volume ID etc). TODO: how to do this?

## Loadbalancer
The reason for considering a Loadbalancer for ingress is such that TLS termination can happen on the Loadbalancer and packets can be inspected before sending to cluster ingress.  Thus ingress will receive plain text. On EKS, we will assume that the connection between Loadbalancer and cluster machines in secure (Wireguard cannot be installed, it does not work on Cloud). 

