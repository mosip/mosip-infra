# Desired state file (DSF)

The helmsman configuration file is also called as “Desired State File (DSF)” which tells the helmsman what applications we want to run and how we want them to set up within kubernetes cluster. when we create a DSF for helmsman we’re essentially providing a set of rules that helmsman should follow to manage our applications on kubernetes cluster.

The Instructions that include within DSF:

* which helm chart to use.
* configuration values
* dependencies between the helm charts.
* desired state.
* environment specific configuration.

### The desired state file consists of:

* Metadata [Optional] -- metadata for any human reader of the desired state file.
* Certificates [Optional] -- only needed when you want Helmsman to connect kubectl to your cluster for you.
* Context [optional] -- define the context in which a DSF is used.
* Settings [Optional] -- data about your k8s cluster and how to deploy Helm on it if needed.
* Namespaces -- defines the namespaces where you want your Helm charts to be deployed.
* Helm repos [Optional] -- defines the repos where you want to get Helm charts from.
* Apps -- defines the applications/charts you want to manage in your cluster.

### Deploy Pre-requisites and External services of mosip

To deploy Pre-requisites and External services of mosip we have two dsf files i,e 

* `prereq-dsf.yaml`: Installs Pre-requisites such as monitoring, logging, alerting, istio, httpbin and global_configmap.  
* `external-dsf.yaml`: Intsalls all the External services of mosip.

Make sure to update the above two dsf files with the required configuration changes as per the environement and also update the `global_configmap.yaml` file with the required domain's then initiate the `helmsman_external.yml` workflow file.

### Note: 
* Commit and push changes to this `deployment/v3/helmsman/dsf/` directory will automatically trigger the workflow to fetch the latest changes and apply to the cluster. 
* Make sure to maintain seperate dsf files per each environment for maintainence and reproducability.