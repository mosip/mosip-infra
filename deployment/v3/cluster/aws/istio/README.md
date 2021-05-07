# Istio

## Install
Download istio package and follow the procedure given [here](https://istio.io/latest/docs/setup/install/helm/). The below shell script executes these steps:
```
./install.sh
```
1. Point your domain name to the load balancer as given [here](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-elb-load-balancer.html)
1. Make sure load balancer points to health check ports for all health checks.  Health check ports used by Istio is given [here](https://istio.io/latest/docs/ops/deployment/requirements/#ports-used-by-istio). You need to point LB to *node port* corresponding to the health check port (15021) which may be obtained as below:
    ```
    $ kubectl -n istio-system get svc istio-ingressgateway
    ```
1. To check the connections you may install [httpbin](../../../utils/httpbin)

