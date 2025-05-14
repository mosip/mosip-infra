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

### Deploy Mosip core services

To deploy Mosip corde service we have below dsf file i,e 
* `mosip-dsf.yaml`: Install all the Mosip core services .

---

## Key Customization Areas In mosip-dsf To Deploy Mosip Core Service

### 1. Helm Configuration
**Default Configuration**  
- `helmDefaults`  
  - `tillerNamespace`: kube-system  
  - `tillerless`: true  
  - `install`: true  
> *Kept unchanged in the customized version.*

---

### 2. Helm Repositories
**Default Configuration**  
- `helmRepos`  
  - `bitnami`: https://charts.bitnami.com/bitnami  
  - `mosip`: https://mosip.github.io/mosip-helm  
> *Kept unchanged in the customized version.*

---

### 3. Namespace Configuration
**Modifications**  
- Created multiple namespaces for different MOSIP components  
- Set `protected: false` for all namespaces  
- Key namespaces include:  
  - conf‑secrets  
  - config‑server  
  - artifactory  
  - captcha  
  - keymanager  
  - …and 17 more (22 in total)

---

### 4. Applications Configuration

#### 4.1 Config Server
- Custom configuration with multiple Git repositories:  
  - Type: git, URI: https://github.com/mosip/inji-config, Version: develop  
  - Type: git, URI: https://github.com/mosip/mosip-config, Version: soil‑helmsman
  - Example:

```
    set:
      image.repository: "mosipqa/kernel-config-server"
      image.tag: "develop"
      gitRepo.uri: "https://github.com/mosip/mosip-config" 
      gitRepo.version: "soil-helmsman"
      gitRepo.searchFolders: ""
      gitRepo.private: "false"
      gitRepo.username: ""
      gitRepo.token: ""
      resources.limits.cpu: "500m"
      resources.limits.memory: "2000Mi"
      resources.requests.cpu: "200m"
      resources.requests.memory: "1000Mi"
      spring_profiles.enabled: true
      spring_profiles.spring_profiles_active: "composite"
      spring_profiles.spring_compositeRepos[0].type: "git"
      spring_profiles.spring_compositeRepos[0].uri: "https://github.com/mosip/inji-config"
      spring_profiles.spring_compositeRepos[0].version: "develop"
      spring_profiles.spring_compositeRepos[0].spring_cloud_config_server_git_cloneOnStart: true
      spring_profiles.spring_compositeRepos[0].spring_cloud_config_server_git_force_pull: true
      spring_profiles.spring_compositeRepos[0].spring_cloud_config_server_git_refreshRate: 5
      spring_profiles.spring_compositeRepos[1].type: "git"
      spring_profiles.spring_compositeRepos[1].uri: "https://github.com/mosip/mosip-config"
      spring_profiles.spring_compositeRepos[1].version: "soil-helmsman"
      spring_profiles.spring_compositeRepos[1].spring_cloud_config_server_git_cloneOnStart: true
      spring_profiles.spring_compositeRepos[1].spring_cloud_config_server_git_force_pull: true
      spring_profiles.spring_compositeRepos[1].spring_cloud_config_server_git_refreshRate: 5
      spring_profiles.spring_fail_on_composite_error: false
      localRepo.enabled: false
      localRepo.spring_profiles_active: "native"
      localRepo.spring_cloud_config_server_native_search_locations: "file:///var/lib/config_repo"
      localRepo.spring_cloud_config_server_accept_empty: true
      localRepo.spring_cloud_config_server_git_force_pull: false
      localRepo.spring_cloud_config_server_git_refreshRate: 0
      localRepo.spring_cloud_config_server_git_cloneOnStart: false
      volume.name: "config-server"
      volume.storageClass: "nfs-client"
      volume.accessModes[0]: "ReadWriteMany"
      volume.size: "10Mi"
      volume.mountDir: "/var/lib/config_repo"
      volume.nfs.path: ""
      volume.nfs.server: ""
```

#### 4.2 Image Repositories
- Registries used:  
  - mosipdev  
  - mosipid  
  - mosipqa  
- Tags in use:  
  - develop  
  - release‑1.3.x  
  - specific version tags
  - Example:
```
    set:
      image.repository: "mosipdev/artifactory-server"
      image.tag: "release-1.3.x"
```

#### 4.3 Resource Configurations
- Resource limits and requests defined for several services:  
  - Limits: CPU 500m, Memory 2000Mi  
  - Requests: CPU 200m, Memory 1000Mi
  - Example:
```
    set:
      image.repository: ""
      image.tag: ""
      resources.limits.cpu: 500m
      resources.limits.memory: 3500Mi
      resources.requests.cpu: 500m
      resources.requests.memory: 3500Mi
      startupProbe.failureThreshold: 100
```

#### 4.4 Istio Configuration
- Host configurations and CORS policy:  
  - Hosts: prereg.soil.mosip.net  
  - CORS Allow Origins: https://admin.soil.mosip.net
  - Example:
```
    set:
      image.repository: "mosipdev/partner-management-service"
      image.tag: "develop"
      istio.corsPolicy.allowOrigins[0].prefix: "https://pmp.soil.mosip.net"
      istio.corsPolicy.allowOrigins[1].prefix: "https://pmp-revam.soil.mosip.net"
```

#### 4.5 Persistent Volume Configurations
- PVC and storage class settings:  
  - Storage Class: nfs‑client  
  - Access Modes: ReadWriteMany  
  - Size: 10Mi
  - Example:

```
    set:
      persistence.enabled: false
      volumePermissions.enabled: false
      persistence.size: <volume_size>
      persistence.mountDir: "<volume_mount_path>"
      persistence.pvc_claim_name: "<PVC_CLAIM_NAME>"
```

---

### 5. Priority‑Based Deployment
- Implemented a priority‑based deployment strategy  
- Priorities range from –15 (highest) to –1 (lowest)  
- Ensures critical services are deployed first
- Example:
```
    priority: -8
```
---

### 6. Hooks Configuration
- Added post‑install and pre-install hooks for various services, including:  
  - Setting up namespaces  
  - Copying configurations  
  - Preparing environments
  - Example:
```
    hooks:
      preInstall: "kubectl label ns artifactory istio-injection=enabled --overwrite"
      postInstall: "../hooks/common-cm-and-secret-sharing.sh"
```

## Deployment Considerations
- Ensure all referenced Git repositories and image tags are accessible  
- Verify network policies and storage configurations  
- Confirm Istio mesh settings and namespace protections align with your infrastructure

---

## Recommended Steps
1. **Review & Validate** each service configuration  
2. **Test** component interactions in a staging environment  
3. **Verify** persistent volume claims and data persistence  
4. **Validate** Istio ingress, virtual services, and gateways

---

> **Note:** This guide provides a high‑level overview. Always refer to the actual DSF Helm charts and values files for precise configuration details.  


### Note: 
* Commit and push changes to this `deployment/v3/helmsman/dsf/` directory will automatically trigger the workflow to fetch the latest changes and apply to the cluster. 
* Make sure to maintain seperate dsf files per each environment for maintainence and reproducability.