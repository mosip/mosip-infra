# httpbin

This utility docker returns http headers received inside the cluster.  You may use it for general debugging - to check ingress, headers etc. 

Install:
```
./install.sh
```

To see what's reaching httpbin (example, replace with your domain name):
```
curl https://api.sandbox.xyz.net/httpbin/get?show_env=true
curl https://api-internal.sandbox.xyz.net/httpbin/get?show_env=true
```

