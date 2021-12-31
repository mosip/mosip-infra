# Metallb Setup

* Edit the sample config map to suit the ip range or to add address pools. Give the ip-range the same as the internal ip range of the nodes.
  * Multiple Address pools can be added in the configmap. And during the time of deploying loadbalancer services, we can choose between these address pools, using service annotations.
* Create `metallb-system` namespace.
  ```
  kubectl create ns metallb-system
  ```
* Deploy the configmap.
  ```
  kubectl apply -f metallb/metallb-configmap.yaml
  ```
* Deploy metallb using bitnami helm chart.
  ```
  KUBECONFIG="$HOME/.kube/rancher_iam.config"
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm install metallb bitnami/metallb -n metallb-system --set existingConfigMap=metallb-configmap
  ```
* TODO: Read more into bgp and layer2 protocols.
