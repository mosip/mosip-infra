# Wireguard Bastion Host

## Server install
* Create a VM (Ubuntu Server recommended) and make sure the VM has access to internal load balancer (it could be in the same VPC). 
* Install Wireguard on your server (could be a landing/jump server) using Docker as given [here](https://hub.docker.com/r/linuxserver/wireguard).
* If you already have a config file you may mount it with `-v <your host path>:/config`.
* You may increase the number of peers keeping the above mounted file intact, stopping the docker and running it again with `-e PEERS=<number of peers>`

## Client install
* Install a Wireguard app on your machine.  For MacOS there is a Wireguard app on the App Store.
* Enter the server docker and cd to `/config` folder.  Here you will find the config files for peers. You may add the corresponding `peer.conf` file in client Wireguard config.
* Make sure `Endpoint` mentioned for the client is server's IP adddress.
* Modify the `Allowed IPs` of the client to restrict it only IPs of interest otherwise all your client traffic will go over Wireguard.  For example, if Wireguard bastion routes traffic to internal load balancer, specify all the private IPs of the same under `Allowed IPs`.

## Wiregard on bastion host
If you would like to restrict public access to your deployment/sandbox/cluster, add a bastion server as follows:
![](images/wireguard_landing.jpg)
* Create a cloud VM instance in the same VPC (Virtual Private Cloud) as your bastion host.  The VM need not be of high capacity as this server is only a Wireguard end point.
* Make sure load balancer (LB) is not public facing; it has an internal domain name (with possibly multiple IPs)
* Point your cluster external access to LB internal domain name.  On AWS this has to be set on Route 53. Example:
```
api.mosip.xyz.net  -->  Internal LB domain name
```  
* Set the end point of Wireguard client to this bastion host.
* Set `AllowedIPs` on Wireguard client to point to all IP addresses of internal LB.
* Now you should be able to access `https://api.mosip.xyz.net` via the Wireguard tunnel.
