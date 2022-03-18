# Nginx Reverse Proxy

## Overview
This document describes how to install and setup Nginx reverse proxy that directs traffic to Ingress controller running on K8s cluster.

## Prerequisites
* Ubuntu (or Debian based OS).
* Command line utilities:
  * `ip`.
  * `docker`(only for wireguard bastion setup).
* The SSL certificate and key pair to be copied into this machine. The script will prompt for the path to these.
  * To get wildcard ssl certificates using letsencrypt, use [this](../../../docs/wildcard-ssl-certs-letsencrypt.md).

## Installation
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
