# MOSIP Components Installation 
  
## Console machine setup
Your Ansible scripts run on the console machine.  The machine should be in the same network as k8s cluster machines.  You may work on this machine as non-root user.
* Change hostname of console machine to `console`.
* Create a (non-root) user account on console machine.
* Change "PasswordAuthentication no" to "PasswordAuthentication yes" in /etc/ssh/sshd_config. And restart sshd.
* Create ssh keys using `ssh-keygen` and place them in ~/.ssh folder:
```
$ ssh-keygen -t rsa
```
No passphrase, all defaults.
* Include current user in /etc/sudoers file with no password. 
* Install Ansible
```
$ sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
$ sudo yum install ansible # This will install 2.9 version
```
* Install git:
```
$ sudo yum install -y git
```
* Git clone this repo in user home directory.

* Set root user password, say `rootpassword`.

## K8s cluster machine setup
* Set up kubernetes machines with following hostnames:
  * `kubemaster`
  * `kubeworker0`
  * `kuberworker1`  
   ...  
   ...  
* If you have more nodes in the cluster add them to `hosts.ini`.   
* Make sure hostname in Ansible inventory `hosts.ini` match with actual hostnames.
* Enable root login to all the machines with same password as above `rootpassword`.

## Running Ansible scripts
```
$ ansible-playbook -i hosts.ini site.yml

To run individual roles, use tags, e.g
```
$ ansible-playbook -i hosts --tags postgres site.yml
```

