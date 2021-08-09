# Wireguard Bastion Host

Contents:
1. On cloud clusters
2. On-prem clusters

## 1. On Cloud

### Introduction
If you would like to restrict public access to your deployment/sandbox/cluster, add a bastion server as follows:
![](images/wireguard_landing.jpg)

### Server install
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

### Client install
* Install a Wireguard app on your machine.  For MacOS there is a Wireguard app on the App Store.
* Enter the server docker and cd to `/config` folder.  Here you will find the config files for peers. You may add the corresponding `peer.conf` file in client Wireguard config.
* Make sure `Endpoint` mentioned for the client is Wireguard bastion hosts' IP adddress.
* Modify the `Allowed IPs` of the client to private IP addresses for Internal Load Balancers of your clusters.  Here, we assumed that all your clusters are running in the same VPC so that bastion host is able to reach all of them.

## 2. On-Prem

TODO: Sync this procedure with the above. For now make the wireguard bastion installation of on prem seperate from cloud because, it might cause complications with nginx + wireguard mesh. For now, one can use any of the both procedure for any type of system(coud/on-prem) but these are the tested and recommended ways of installing it.

* Installation: `sudo apt install wireguard` on ubuntu based machines. For Windows and Macos there are dedicated apps. Else refer to [this](https://www.wireguard.com/install/)
* Create privkey-pubkey pair.
  ```
  mkdir wg-keys && cd wg-keys
  wg genkey | tee privkey | wg pubkey | tee pubkey
  ```
* Create bastion server wg-interface config.
  * Get the server privkey and pubkey from the above created files.
  * Share your pubkey with peers, and ask them for their pubkey.
    <details>
      <summary>Sample server wg interface config</summary>

      Follow the ip convention like;<br>
      Server wg ip= Self assign <br>
      peer1 wg ip = server wg ip + 1<br>
      peer2 wg ip = peer1 + 1<br>
      peer3 wg ip = peer2 + 1 , etc<br>
      ```
      [Interface]
      # Name = Wireguard Bastion
      PrivateKey = <server-pubkey>
      Address = <Server-wireguard-ip>/32
      ListenPort = 51820

      [Peer]
      # Name = Peer1
      PublicKey = <Peer1-pubkey>
      AllowedIPs = <Peer1-wg-ip>/32

      [Peer]
      # Name = Peer2
      PublicKey = <Peer2-pubkey>
      AllowedIPs = <Peer2-wg-ip>/32
      ```
    </details>

    <details>
      <summary>Sample Peer wg interface config</summary>

      Following is for Peer1<br>
      Other peers also should create similarly<br> Server will give its public key, its public ip, this peer's wg-ip
      ```
      [Interface]
      # Name = Peer1
      PrivateKey = <Peer1-priv-key>
      Address = <Peer1-wg-ip>/32
      ListenPort = 51820

      [Peer]
      # Name = Server
      PublicKey = <Server-pubkey>
      Endpoint = <Server-public-ip>:51820
      AllowedIPs = <Server-wg-ip>/32, <Nginx-node-internal-ip>/32
      ```
    </details>
    
  * On Linux machines:
    * Put the above configs in `/etc/wireguard/<desired-interface-name>.conf` file. This name of this `.conf` file is later used to call up the wg interface.
    * Use `wg-quick up <interface-name>` to bring up the interface.
    * Use `wg-quick down <interface-name>` to bring down the interface.
    * Use `sudo systemctl enable wg-quick@<interface-name>` to make this wireguard interface come up at boot, as a systemctl service.
  * On Windows and Mac:
    * These configs can be written to any file, and then that file can be imported into the wireguard app.
    * Or there is option to directly paste the config into the wireguard app.
  * All peers can ping the server now, with the server-wg-ip.
  * After that, server should also be able to ping its peers.
