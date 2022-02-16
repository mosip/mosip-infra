## Install Oauth2-Proxy in cluster.

This directory contains files that can be used to install oauth2-proxy in a given cluster. This will also install and setup a new realm in keycloak, `istio`. (If such a realm is already present it needs to be deleted manually. (TODO: develop this to use pre-existing istio realm))

### Installation:

```sh
./install.sh <cluster_kube_config_file>
```
After installation is done, go to `istio` realm in keycloak and create required users and assign appropriate roles

### Applying Policies

- There are two policies provided in the `sample-auth-policy.yaml`, they work like this. First the CUSTOM auth policy will authenticate the incoming request (this custom auth provider is oauth2-proxy), then the second DENY filter will deny the request if it didnt receive the appropriate role binding.
- After installation, use the following script to apply policies on cluster.
```sh
./apply_policy.sh sample-auth-policy.yaml <cluster_kube_config_file>
```
- These policy are just regular istio resources and can be applied manually without the script also (like `kubectl apply -f`).
- But the script replaces varibles like `h__mosip-api-internal-host__h`, `h__mosip-kibana-host__h`, etc from global configmap in cluster, before applying. So that one doesnt have to care about the hostname while applying.
- To remove the policies; `kubectl delete -f sample-auth-policy.yaml`

### Setting appropriate roles for urls
Edit the sample-auth-policy.yaml for setting roles for each set of hosts and uris, and apply the policy

### To Uninstall
```
kubectl delete ns oauth2-proxy
```
Also dont forget to remove the policies seperately. `kubectl delete -f sample-auth-policy.yaml`

### Notes:

- Find the conf of `istio` realm in `istio-realm.json` file.
- Find the conf of oauth2-proxy installation in the `oauth2-proxy.yaml` file
- Find the istiod configuration of external authorization in the istio-operator file.
