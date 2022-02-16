# Nginx Reverse Proxy

### Overview
This document describes how to install and setup nginx reverse proxy into the ingress controller.

### Prerequisites
* The `install.sh` script needs OS to be debian based, linux machine(s). (Ideally an Ubuntu Server)
* The following commandline utilities needed
  * `ip`,`bash`,`sed`,`docker`(optional, only required for wireguard bastion setup)
* The SSL certificate and key pair to be copied into this machine. The script will prompt for the path to these.

### Installation
* Run the script as ROOT user, or equivalent (sudo).
```
$ sudo ./install.sh
or
# ./install.sh
```
* The following takes an optional argument `+wg`, which can install wireguard bastion server also on the same machine. This will also need an `WG_DIR` env variable.
```
WG_DIR=<path-to-wg-dir> sudo ./install.sh +wg
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
sudo rm -rf wgbaseconf wgconf
```
</details>
