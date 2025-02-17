# Desired state file (DSF)

The Helmsman configuration file is also known as the Desired State File (DSF). It defines the applications we want to deploy and how they should be configured within a Kubernetes cluster. When we create a DSF for Helmsman, we provide a set of rules that Helmsman follows to manage applications on the cluster.

Instructions Included in the DSF
The DSF specifies:

* which helm chart to use.
* configuration values
* dependencies between the helm charts.
* desired state.
* environment specific configuration.

### Structure of the Desired State File
The DSF consists of the following components:

* Metadata [Optional] -- metadata for any human reader of the desired state file.
* Certificates [Optional] -- only needed when you want Helmsman to connect kubectl to your cluster for you.
* Context [optional] -- define the context in which a DSF is used.
* Settings [Optional] -- data about your k8s cluster and how to deploy Helm on it if needed.
* Namespaces -- defines the namespaces where you want your Helm charts to be deployed.
* Helm repos [Optional] -- defines the repos where you want to get Helm charts from.
* Apps -- defines the applications/charts you want to manage in your cluster.

### Deploying Pre-requisites and External Services for MOSIP
To deploy pre-requisites and external services for MOSIP, we use two DSF files:

* `prereq-dsf.yaml`: Installs Pre-requisites such as monitoring, logging, alerting, istio, httpbin and global_configmap.  
* `external-dsf.yaml`: Intsalls all the External services of mosip.

### Configuration Updates
Before running the deployment, ensure:
To update the above two dsf files with the required configuration changes as per the environement requirements then initiate the `helmsman_external.yml` workflow file.

### Note: 
* Replace `<placeholders>`
* Any commit and push to the `deployment/v3/helmsman/dsf/` directory will automatically trigger the workflow to fetch the latest changes and apply to the cluster. 
* Make sure to maintain seperate dsf files per each environment for maintainence and reproducability.
* If in case using Custom values for any application then provide the values file like below example:

  Replace `<values_file>` with `[es_values.yaml](https://raw.githubusercontent.com/mosip/k8s-infra/develop/logging/es_values.yaml)`
