# NGINX Reverse Proxy Setup

* On on prem systems, loadbalancers (usually metallb), will be chosen to run on the internal subnet.
* We can then dedicate a node that run on the same internal subnet as above, which run an nginx reverse proxy into the loadbalancer. And this can accessed publicly.

## 1. Intial Setup

* Provision one VM for Nginx. Or multiple VMs for high avaiability like Nginx Plus.
* The machine should be external facing with public ip and DNS like `api.mosip.xyz.net`.
  * Full dns refer to [this](../../global_configmap.yaml.sample)
  * Example `rancher.mosip.xyz.net` should point to the nginx node internal ip.
* TLS termination will happen here. The traffic will be forward to cluster ingress over HTTP.
  * Make sure you have SSL certificate for the above domain so that HTTPS is enabled.
  * To get wildcard ssl certificates using letsencrypt, use [this](../../../docs/wildcard-ssl-certs-letsencrypt.md).
* Make sure the metallb loadbalancer ips are reachable from this nginx node.
  * To test whether nginx node can reach the loadbalancer ip, we can use curl.
    ```
    kcr get svc -n istio-system
    curl http://<loadbalancer-ip>
    ```
  * If it is not reachable or gives `No route to host`, add an route in the routing table.
    ```
    sudo ip route add <loadbalancer-ip> via <first-cluster-node-ip>
    ```
* `sudo apt install nginx`
* Edit the nginx.conf file, like the [sample](./sample-nginx.conf) provided. See section 2 in this document.
* Test config and start/restart nginx
  * For systemctl based linux systems, use:
    ```
    sudo nginx -t
    sudo systemctl restart nginx
    ```
  * For others use;
    ```
    sudo nginx -t
    sudo nginx -s reload
    ```

## 2. Configuring servers in nginx.conf

* Each server section in the config corresponds to one particular ip/ dns name.
* Ip values in `listen` directive are the ips that the nginx server listens on. There we have to provide the nginx internal interface ip/ public interface ip, accordingly.
* Ip values in `proxy_pass` directive are the destination ips to what we want to proxy to. There we have to provide loadbalancer ips.
* Edit the config so that, in the first server all requests to nginx-node internal interface, with the server_name(host name) of rancher and iam, go to the rancher-cluster-ingressgateway-loadbalancer.
* Edit the second server so that rest of all requests to nginx-node internal interface should go to the mosip-cluster-internal-ingressgateway-loadbalancer. (Here `server_name` need not be specified, instead use the tag `default_server`, check sample)
* Edit the third server so that all requests to nginx-node-public-interface-ip should go to the mosip-cluster-internal-ingressgateway-loadbalancer. (Here also no need to specify `server_name` or `default_server`)
* Any no of servers can be added depending on the ise case.
* There is also a `stream` section, which is used to proxy raw TCP traffic. Add any no of servers there also, one for each port that is to be exposed. This port has to be open on the loadbalancer to which this has to be proxied to.
