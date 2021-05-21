# httpbin

This utility docker returns http headers received inside the cluster.  You may use it for general debugging - to check ingress, headers etc. 

Install:
```
$ ./install.sh
```

To see all headers:
```
curl https://api.sandbox.mosip.net/httpbin/headers?show_env=true
```

