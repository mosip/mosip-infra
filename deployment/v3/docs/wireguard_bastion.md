# Wireguard Bastion Host

## Introduction
If you would like to restrict public access to your deployment/sandbox/cluster, add a bastion server as follows:
![](images/wireguard_landing.jpg)

## Server install
* Create a VM (Ubuntu Server recommended) and make sure the VM has access to internal load balancer (it could be in the same VPC). This may be simply achieved by running the VM in the same VPC as the cluster. The VM need not be of high capacity as this server is only a Wireguard end point.
* Install docker, and make sure you add `$USER` to docker group:
```
sudo usermod -aG docker $USER
```
* Install Wireguard on the VM using Docker as given [here](https://hub.docker.com/r/linuxserver/wireguard). Sample config :
```
docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Calcutta\
  -e PEERS=30 \
  -p 51820:51820/udp \
  -v /home/ubuntu/config:/config \
  -v /lib/modules:/lib/modules \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \
  ghcr.io/linuxserver/wireguard
```
* If you already have a config file you may mount it with `-v <your host path>:/config`.
* You may increase the number of peers keeping the above mounted file intact, stopping the docker and running it again with `-e PEERS=<number of peers>`
* 
## Client install
* Install a Wireguard app on your machine.  For MacOS there is a Wireguard app on the App Store.
* Enter the server docker and cd to `/config` folder.  Here you will find the config files for peers. You may add the corresponding `peer.conf` file in client Wireguard config.
* Make sure `Endpoint` mentioned for the client is Wireguard bastion hosts' IP adddress.
* Modify the `Allowed IPs` of the client to private IP addresses for Internal Load Balancers of your clusters.  Here, we assumed that all your clusters are running in the same VPC so that bastion host is able to reach all of them. 

