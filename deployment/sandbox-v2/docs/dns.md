## DNS
By default a private DNS (CoreDNS) is installed on the console machine and `/etc/resolv.conf` on all machines points to this DNS.  However, if you would like to use cloud providers DNS (like Route53 on AWS), disable the private DNS installation by setting the following flag in `group_vars/all.yml`:
```
coredns:
  enabled: false  # Disable to use Cloud provided DNS 
```
Make sure your cloud deployment takes care of DNS routing.  For AWS, uncomment the Route53 code in the scripts provided in `terraform/aws/sandbox`

The playbook `corends.yml` sets up CoreDNS and updates `/etc/resolv.conf` file on all machines.  In case a machine has to be rebooted, run the playbook again to restore `/etc/resolv.conf`.

