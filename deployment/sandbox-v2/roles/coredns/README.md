## Context
For on-prem setups we need a DNS server to resolve names of console and kubernetes machines.  CoreDNS is a docker based DNS server that may be used for this purpose.  Typically cloud services provide a DNS within the virtual private cloud.  However, to make the installation of sandbox uniform we recommend using this DNS server so that dependency and specficity to a particular cloud is eliminated.  In production cloud based environments it will be more prudent to use DNS provided by the CSP.

## Setup
The scripts here accomplish the following:
1.  Install CoreDNS docker on console machine which is used as the DNS server
1.  Create DNS config files and mount them in the docker  

The IP address are picked up from `hosts.ini` file.  

Further, `/etc/resolv.conf` in all machines needs to be updated to point to the console machine.  This is done in playbook `corends.yml`.

