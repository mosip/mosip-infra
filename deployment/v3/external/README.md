# MOSIP External Components

## Overview
* This folder contains installation procedures for all components that are not part of core MOSIP offering - they need to be installed separately and integrated.
* MOSIP has provided reference/mock implementations of some of these components that may be used for development and testing.
* Some components may run inside the cluster itself, or outside depending on the choice of deployment. 

## External components
* Global configmap: In MOSIP `global` configmap in `default` namespace contains Domain related information.
  * Make sure kubeconfig file is already set and k8 cluster is accessible and kubectl is installed.
  * Copy `global_configmap.yaml.sample` to `global_configmap.yaml`.
  * Retrieve the Kibana Host Entered During Logging Deployment
    To retrieve the Kibana Host that was entered by the user as part of the logging deployment, run the following command:
    ```
    kubectl -n <namespace> get configmap <cm-name> -o=jsonpath='{.data.mosip_kibana_host}'
    ```
    Replace <namespace> with the relevant Kubernetes namespace where the ConfigMap is stored.
    Replace <cm-name> with the name of the ConfigMap that contains the Kibana Host data.
    This command will extract and display the value of the mosip_kibana_host key from the specified ConfigMap.
    Update the same host name in gobal_configmap and then apply.
  * Update the domain names in `global_configmap.yaml` and execute:
    ```
    kubectl apply -f global_configmap.yaml
    ```
* [Istio-gateway](istio-gateway/README.md)
* [Postgres](postgres/README.md)
* [IAM (Keycloak)](iam/README.md)
* [HSM](hsm/README.md)
* [Object Storage](object-store/README.md)
* [Anti-virus (Clamav)](antivirus/clamav/README.md)
* [ActiveMQ](activemq/README.md)
* [Kafka](kafka/README.md)
* [BioSDK](biosdk/README.md)
* [ABIS](abis/README.md)
* [Message Gateways](msg-gateway/README.md)
* [docker secrets](docker-secrets/README.md)
* [captcha](captcha/README.md)
* [Landing page](landing-page/README.md)
## Install
* Run `install-all.sh` script to install in defined sequence.
```
cd all
./install-all.sh
```
