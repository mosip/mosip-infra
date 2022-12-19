# Wireguard Mesh

## Introduction
Internode communication may be secured by running Wireguard on all nodes in a mesh configuration (as opposed to typical client-server configuration).  Here, all the peers are connected to each other in a Wireguard mesh.  Wireguard needs to be installed *before* you install your on-prem kubernetes cluster.

The instructions given here are for Ubuntu.  You may modified them accordingly for your OS distribution.

These are NOT instructions for [Wireguard Bastion host](https://docs.mosip.io/1.2.0/deployment/wireguard/wireguard-bastion) setup.

## Prerequisites
1. You have an admin/control machine from where you run your scripts.
1. Virtual machines (nodes) are provisioned and accessible from admin machine.
1. The `ssh` private keys required to access nodes are available in your `~/.ssh/` folder.
1. Ansible is installed as given [here](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu)
1. Wireguard mesh configuration tool [wg-meshconf](https://github.com/k4yt3x/wg-meshconf) is installed.

## Install
1. Create `hosts.ini` file using `hosts.ini.sample` as example.
    * `wg_address` is arbitrary as long as it does not clash with any other addresses.
    * `[control]` is your admin machine from where you are running these scripts.
1. Install Wireguard on all nodes:
    ```
    $ ansible-playbook -i hosts.ini install.yaml
    ```
1. Setup wireguard mesh configuration file for each node and copy the same to `/etc/wireguard/wg0.conf` of respective node.
    ```
    $ ansible-playbook -i hosts.ini setup.yaml
    ```
1. Bring up wireguard on all nodes
    ```
    $ ansible-playbook -i hosts.ini up.yaml
    ```
## Adding or updating peers
If you have need to add a new peer or change any parameter of existing peer, run the following sequence:
1. Shutdown wireguard
    ```
    $ ansible-playbook -i hosts.ini setup.yaml
    ```
1. Make the required changes in `hosts.ini`
1. Run setup again
    ```
    $ ansible-playbook -i hosts.ini setup.yaml
    ```
1. Bring up wireguard.
    ```
    $ ansible-playbook -i hosts.ini up.yaml
    ```
