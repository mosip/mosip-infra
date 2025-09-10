## Install Oauth2-Proxy in cluster.

This directory contains files that can be used to install oauth2-proxy in a given cluster.

### Installation:

- Login to MOSIP cluster keycloak (ex: `iam.sandbox.mosip.net`) as `admin`.
- Click on *Add Realm*, on top left of admin console.
- Click on *Select File* on Import. And select the `istio-realm.json` file in this directory.
- Give *name* as `istio`. Switch on *Enabled*.
- Click *Create*.
- After the realm is created, configure the *frontendUrl* on *Realm Settings* page of the `istio` realm. (Example: `frontendUrl: https://iam.sandbox.mosip.net/auth`)
- Then navigate to *Clients* page, and to the `istio-auth-client`.
- Go to *Credentials* section, and *Regenerate Secret*.
- Copy the new secret for further use.
- Then run the install script:
  ```sh
  ./install.sh <cluster_kube_config_file>
  ```
- After installation is done, go to `istio` realm in keycloak and create required users and assign appropriate roles.

### Applying and removing policies

- After installation, use the following script to apply policies on cluster.
  ```sh
  ./apply_policy.sh sample-auth-policy.yaml <cluster_kube_config_file>
  ```
- To remove the policies;
  ```sh
  kubectl delete -f sample-auth-policy.yaml
  ```

### Setting appropriate roles for urls
Edit the sample-auth-policy.yaml for setting roles for each set of hosts and uris, and apply the policy

### Uninstall
```sh
./delete.sh <cluster_kube_config_file>
```
Also dont forget to remove the policies seperately. `kubectl delete -f sample-auth-policy.yaml`

### Notes:

- Find the conf of `istio` realm in `istio-realm.json` file.
- Find the conf of oauth2-proxy installation in the `oauth2-proxy.yaml` file
- Find the istiod configuration of external authorization in the istio-operator file.
- There are two policies provided in the `sample-auth-policy.yaml`, they work like this. First the CUSTOM auth policy will authenticate the incoming request (this custom auth provider is oauth2-proxy), then the second DENY filter will deny the request if it didnt receive the appropriate role binding.
- Using the `apply_policy.sh` script, replaces variables like `h__mosip-api-internal-host__h`, `h__mosip-kibana-host__h`, etc in the policy, before applying (values taken from global configmap of cluster).
