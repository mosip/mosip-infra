# NGINX Reverse Proxy Setup

## Introduction
Nginx is used as a reverse proxy to direct traffic into the cluster via two channels - public and internal. The internal channel is front-ended by Wireguard. The traffic is directed to NodePort of respective Ingress gateways (Istio). The Nginx runs on a separate node that has access to public Internet.

## Prerequisites
* Provision one VM for Nginx. Or multiple VMs for high avaiability like Nginx Plus.
* OS: Debian based. Recommended Ubuntu Server.
* SSL certificate and key pair (for TLS termination) are required. The script will prompt for the path to these.
    * To get wildcard ssl certificates using letsencrypt, use [this](../../../docs/wildcard-ssl-certs-letsencrypt.md).
* Make sure this Nginx node has two network interfaces:
    1.  Public: Facing public Internet.
    1.  Internal: With private IP front-ended by Wireguard. This interface must be on same the same network as the cluster nodes/machines. (In case, provisioning another interface is not possible, create a virtual interface on Lnux like a `tap/macvtap`. A dummy virtual interface also will do.)
* Command-line utilities:
  * `bash`,
  * `sed`
  * `docker`(optional, only required for wireguard bastion setup) 
* Nginx machine details are updated in `../hosts.ini`.

## Installation
### Ports
Enable firewall with required ports:
```
ansible-playbook -i ../hosts.ini nginx_ports.yaml
```
### Nginx + Wireguard
```
WG_DIR=<aboslute-path-of-wg-dir> sudo ./install.sh +wg
```
### Only Nginx
```sh
 sudo ./install.sh
```
## Post installation
* After installation check Nginx status:
```
sudo systemctl status nginx
```
* If you have installed Wireguard, check `WG_DIR` folder. It should contain two folders `wgbaseconf` & `wgconf`:
  * `wgbaseconf` contains public,private key pairs for all peers.
  * `wgconf` contains the actual peer conf files.
  * As a good practice, before sharing the wireguard peer conf file, create a file `assigned.txt` and where you maintain the list of assignments.

## Uninstall
```
sudo apt purge nginx nginx-common
docker rm -f wireguard
sudo rm -rf wgbaseconf wgconf
```
