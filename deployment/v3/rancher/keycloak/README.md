# Keycloak

## Overview
Keycloak is an OAuth 2.0 compliant Identity Access Management (IAM) system used to manage the access to rancher for cluster controls. We will be installing two keycoaks:
  * One for Organisation wide rancher access to manage the different clusters of the otrganisation.
  * Another for MOSIP cluster for authorisation between different modules.

## Install
* Run the install script to install the keycloak as below:
  ```
  ./install.sh <iam.host.name>
  ```
  eg. ./install.sh iam.xyz.net
* `keycloak_client.json`:  Used to create SAML client on Keycloak for Rancher integration.
