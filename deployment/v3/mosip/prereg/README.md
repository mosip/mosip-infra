# Pre-Registration Module

## Install

* Make sure your prereg UI domain name is set in [global configmap](../../cluster/global_configmap.yaml.sample)
* Make sure this domain points to the public load balancer as PreReg UI is exposed to public.
* Install
  ```sh
  ./install.sh
  ```

## Uninstall

```sh
./delete.sh
```

## Test
On a browser open  `https://<prereg ui domain>/pre-registration-ui/`. Example `https://prereg.sandbox.xyz.net/pre-registration-ui`.  Follow the instructions.  You may use [sample documents](samples/) to upload during pre-registration. 

## Rate Control Using Envoyfilter

- Using Envoyfilter one can limit the rate of http requests coming in to a resource. Reference: [Istio Policty Enforcement](https://istio.io/latest/docs/tasks/policy-enforcement/rate-limit/#local-rate-limit) and [Rate Limit Filter](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/local_rate_limit_filter).
- Edit the envoyfilter [here](./rate-control-envoyfilter.yaml)
  - Edit these values in the envoyfilter accordingly.
    ```
    token_bucket:
      max_tokens: <preferred same as tokens_per_fill>
      tokens_per_fill: <no of reqeust allowed in "fill_internal" ammount of time>
      fill_interval: <minimum_50ms>
    ```
  - Edit the workload selector label properly, like;
    ```
    workloadSelector:
      labels:
        app.kubernetes.io/instance: <prereg-ui or prereg-application, etc>
    ```
- Apply the envoyfilter in the prereg namespace.
  ```
  kubectl apply -n prereg -f rate-control-envoyfilter.yaml
  ```
