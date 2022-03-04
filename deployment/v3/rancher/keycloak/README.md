# Keycloak

Contains scripts to install Keycloak in cluster for Rancher. 
* `install.sh`:  Installs Bitnami Keycloak
    * Usage: ./install.sh <iam_host_name> [kube_config_file] 
* `keycloak_client.json`:  Used to create SAML client on Keycloak for Rancher integration.
