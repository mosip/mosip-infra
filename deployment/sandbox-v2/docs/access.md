## Sandbox access
The default sandbox installation requires you to have a public domain name such that the domain name points to console machine. However, if you would like to access sandbox on your internal network (over VPN for example) then set the following in `group_vars/all.yml`:
```
sandbox_domain_name: '{{inventory_hostname}}'
site:
  sandbox_public_url: 'https://{{sandbox_domain_name}}'
  ssl:
    ca: 'selfsigned'   # The ca to be used in this deployment
```
This is will generate a self-signed certificate and the sandbox access url would be `https://<inventory hostname>/` 
