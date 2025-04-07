#!/bin/bash
# Install ingress gateways

#NOTE: istioctl is specific to kubeconfig file. If you've more than one config files, please specify them like mentioned below:
#istioctl --kubeconfig <path-to-config-file> or use -c as shorthand for --kubeconfig.

ISTIO_NS=istio-system
HTTPBIN_NS=httpbin

export ENV="${1:-sandbox}"
export VERSION="${2:-develop}"

echo Operator init
istioctl operator init

function installing_istio_and_httpbin() {
  echo "Installing Global Configmap"
  chmod +x deployment/v3/helmsman/utils/global_configmap.yaml
  envsubst < deployment/v3/helmsman/utils/global_configmap.yaml > ./global_configmap_generated.yaml
  kubectl apply -f global_configmap_generated.yaml
  echo "Installed Global Configmap"

  echo Create ingress gateways, load balancers and istio monitoring
  kubectl apply -f deployment/v3/helmsman/utils/istio-mesh/nodeport/iop-mosip.yaml
  kubectl apply -f deployment/v3/helmsman/utils/istio-monitoring/
  echo Wait for all resources to come up
  sleep 10
  kubectl -n $ISTIO_NS rollout status deploy istiod
  kubectl -n $ISTIO_NS rollout status deploy istio-ingressgateway
  kubectl -n $ISTIO_NS rollout status deploy istio-ingressgateway-internal

  echo ------ IMPORTANT ---------
  echo If you already have pods running with envoy sidecars, restart all of them NOW.  Check if all of them appear with command "istioctl proxy-status"
  echo --------------------------

  echo Installing gateways, proxy protocol, authpolicies
  PUBLIC=$(kubectl get cm global -o jsonpath={.data.mosip-api-host})
  INTERNAL=$(kubectl get cm global -o jsonpath={.data.mosip-api-internal-host})
  echo Public domain: $PUBLIC
  echo Internal dome: $INTERNAL


  ##helm -n istio-system install istio-addons chart/istio-addons --set gateway.public.host=$PUBLIC --set gateway.internal.host=$INTERNAL --set proxyProtocol.enabled=false

  # Check if the internal gateway exists
  internal_exists=$(kubectl get gateway internal -n $ISTIO_NS --ignore-not-found=true)

  # Check if the public gateway exists
  public_exists=$(kubectl get gateway public -n $ISTIO_NS --ignore-not-found=true)

  if [[ -n "$public_exists" && -z "$internal_exists" ]]; then
    echo "Public gateway is present, but internal is not."
    gateway_option="--set gateway.public.enabled=false --set gateway.internal.host=$INTERNAL"
  elif [[ -n "$internal_exists" && -z "$public_exists" ]]; then
    echo "Internal gateway is present, but public is not."
    gateway_option="--set gateway.public.host=$PUBLIC --set gateway.internal.enabled=false"
  elif [[ -z "$public_exists" && -z "$internal_exists" ]]; then
    echo "Neither public nor internal gateway is present."
    gateway_option="--set gateway.public.host=$PUBLIC --set gateway.internal.host=$INTERNAL"
  fi

  if [[ -n "$public_exists" && -n "$internal_exists" ]]; then
    echo "Both public and internal gateways exist. Skipping installation."
  else
    helm -n $ISTIO_NS install istio-addons deployment/v3/helmsman/utils/istio-gateway \
      $gateway_option \
      --set proxyProtocol.enabled=false \
      --wait
  fi

  echo "Installing utility httpbin"
  kubectl label ns $HTTPBIN_NS istio-injection=enabled --overwrite

  kubectl -n $HTTPBIN_NS apply -f deployment/v3/helmsman/utils/httpbin/svc.yaml
  kubectl -n $HTTPBIN_NS apply -f deployment/v3/helmsman/utils/httpbin/deployment.yaml
  kubectl -n $HTTPBIN_NS apply -f deployment/v3/helmsman/utils/httpbin/deployment-busybox-curl.yaml
  kubectl -n $HTTPBIN_NS apply -f deployment/v3/helmsman/utils/httpbin/vs.yaml
  
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_istio_and_httpbin   # calling function
