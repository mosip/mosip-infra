# Nginx Reverse Proxy

## Overview
This document describes how to install and setup Nginx reverse proxy into the ingress controller.

## Prerequisites
* The `install.sh` script needs OS to be debian based, linux machine(s). (Ideally an Ubuntu Server)
* The following commandline utilities needed
  * `ip`,`bash`,`sed`,`docker`(optional, only required for wireguard bastion setup)
* The SSL certificate and key pair to be copied into this machine. The script will prompt for the path to these.

## Installation
* To install just Nginx (without Wireguard), run the script as ROOT user:
```sh
 sudo ./install.sh
```
* To install Nginx + Wireguard bastion host, specify argument `+wg`. 
```
WG_DIR=<path-to-wg-dir> sudo ./install.sh +wg
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
