### Adding / Changing Istio-ingressgateway ports

This doc refers to changing or adding a new port to istio-ingressgateway. This is needed in case non-http related services, like postgres, activemq, etc, are to be exposed over the istio gateway.

#### Using Helm
If the installation of istio is through helm.
* If istio is already installed:
  * If the original override values.yaml is not present use `helm get values` command to get the original user defined values.
  * Download the istio repo, from https://github.com/istio/istio/releases
  * Check the original values.yaml in `manifests/charts/gateways/istio-ingress/values.yaml`.
  * Add your new port and copy all the original ports in values.yaml in `gateways.istio-ingressgateway.ports` into your override values.yaml. Then use this command:
  ```
  $ cd istio-downloaded-repo
  $ helm -n istio-system upgrade istio-ingressgateway manifests/charts/gateways/istio-ingress -f values.yaml
  ```
* If istio is not already installed:
  * Follow the above instructions and create an overide values.yaml. But in the end use `helm install` command instead of upgrade.
  * For full installation https://istio.io/latest/docs/setup/install/helm/
* Sample override values.yaml:
  ```
  gateways:
    istio-ingressgateway:
      labels:
        app: istio-ingressgateway-internal
        istio: ingressgateway-internal
      name: istio-ingressgateway-internal
      # Edit the following serviceAnnotations
      serviceAnnotations: {}
      ports:
      ## You can add custom gateway ports in user values overrides, but it must include those ports since helm replaces.
      # Note that AWS ELB will by default perform health checks on the first port
      # on this list. Setting this to the health check port will ensure that health
      # checks always work. https://github.com/istio/istio/issues/12503
      - port: 15021
        targetPort: 15021
        name: status-port
        protocol: TCP
      - port: 80
        targetPort: 8080
        name: http2
        protocol: TCP
      - port: 443
        targetPort: 8443
        name: https
        protocol: TCP
      - port: 15012
        targetPort: 15012
        name: tcp-istiod
        protocol: TCP
      # This is the port where sni routing happens
      - port: 15443
        targetPort: 15443
        name: tls
        protocol: TCP
      # additional ports
      - port: 61616
        targetPort: 61616
        name: activemq
        protocol: TCP
  ```
