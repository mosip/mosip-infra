# NGINX Reverse Proxy Setup

* On on prem systems, Ingressgateways will be chosen to be exposed as nodeport services.
* We can then dedicate a node that run on the same internal subnet as cluster nodes, which run an nginx reverse proxy into the above nodeports. And this can accessed publicly.

## Prerequisites

* Provision one VM for Nginx. Or multiple VMs for high avaiability like Nginx Plus.
* SSL certificate and key pair (for TLS termination) are required. The script will prompt for the path to these.
  * To get wildcard ssl certificates using letsencrypt, use [this](../../../docs/wildcard-ssl-certs-letsencrypt.md).
* Make sure this nginx node has two network interfaces. One of which has to face external traffic. And one of the interfaces has to be on the same network as the cluster nodes/machines. The public facing interface itself can also be on the same internal network and the second interface can just be a dummy one . Network configuration is left to administrators. (In case provisioning another interface is not possible, one can create a virtual interface in linux like a tap/macvtap. A dummy virtual interface also will do.)
* The `install.sh` script needs OS to be debian based, linux machine(s). (Ideally an Ubuntu Server)
* The following commandline utilities needed
  * `bash`,`sed`,`docker`(optional, only required for wireguard bastion setup) 

## Installation
* Always run the script as root user. (or with sudo)
* The script is interactive and it will prompt for everything required.
* To only install nginx:
```
# ./install.sh
```
* To install nginx with wireguard (docker is required. And the `WG_DIR` is variable and has to be specified in absolute path. This dir will store all the conf files and peer keys):
```
# WG_DIR=$HOME ./install.sh +wg
```
* To install only wireguard:
```
# WG_DIR=$HOME ./install.sh wg
```
<details>
  <summary>For non debian based OSes</summary>

  Replace `apt install` with your respective package manager, like `yum`, `apk`, `pkg`,`brew`, etc.
</details>

### Post-Installation

* After installation one can check nginx installed status:<br/>
`sudo systemctl status nginx`
<details>
  <summary>For Optional Wireguard bastion installation</summary>

  * After initial wg installation, one can check in the given `WG_DIR` there should be two folder `wgbaseconf` & `wgconf`:
  * `wgbaseconf` contains pubkey privkey pairs for all the peers. `wgconf` contains the actual peer conf files.
  * If one wants to run multiple replicas of this `nginx+wireguard` node, one can choose to copy this `wgbaseconf` folder off to the new replicas' `WG_DIR`, and then rerun the script on the new node. This time the pub-priv keypair will be preserved across all the replica nodes.
  * Before sharing the wireguard peer conf file, create a file `assigned.txt` and take a list of all peers
  * Incase of multiple replicas of `nginx+wireguard` node, combine the wg conf files of all the replicas into one conf file as multiple peers.
</details>

### Uninstall
```
sudo apt purge nginx nginx-common
```
<details>
  <summary>If Wireguard bastion also installed, use this to remove it</summary>

```
docker rm -f wireguard
sudo rm -rf $WG_DIR/wgbaseconf $WG_DIR/wgconf
```
</details>
