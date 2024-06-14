## Terraform & Shell Script for Nginx Setup with SSL

## Overview
This Terraform configuration script sets up a Nginx server with SSL certificates on an AWS EC2 instance.
It fetches SSL certificates using Certbot and integrates with Kubernetes infrastructure from a specified GitHub repository

## Requirements

* Terraform version: `v1.8.4`
* AWS Account
* AWS CLI configured with appropriate credentials
  ```
  $ export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
  $ export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
  ```
* Ensure SSH key created for accessing EC2 instances on AWS.
* Ensure you have access to the private SSH key that corresponds to the public key used when launching the EC2 instance.
* Domain and DNS: Ensure that you have a domain and that its DNS is managed by Route 53.
* Git is installed on the EC2 instance.

## Files
* `main.tf`: Main Terraform script that defines providers, resources, and output values.
* `nginx-setup.sh`: This scripts install and setup nginx configuration.

## Setup
* Initialize Terraform
  ```
  terraform init
  ```
* Terraform validate & plan the terraform scripts:
  ```
  terraform validate
  ```
  ```
  terraform plan -var-file="aws.tfvars"
  ```
* Apply the Terraform configuration:
  ```
  terraform apply -var-file="aws.tfvars"
  ```

## Destroy
To destroy AWS resources, follow the steps below:
* Ensure to have `terraform.tfstate` file.
  ```
  terraform destroy
  ```

## Input Variables
* `NGINX_PUBLIC_IP`: The public IP address of the EC2 instance where Nginx will be set up.
* `MOSIP_DOMAIN`: The domain for which the wildcard SSL certificates will be generated.
* `MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST`: A comma-separated list of Kubernetes cluster node's private IP addresses for Nginx configuration.
* `MOSIP_PUBLIC_DOMAIN_LIST`: A comma-separated list of public domain names associated for Nginx configuration.
* `CERTBOT_EMAIL`: Email address to be used for SSL certificate registration with Certbot.

## Local Variables
The script `main.tf` defines a local variable NGINX_CONFIG containing various configuration parameters required for setting up Nginx and obtaining SSL certificates.

## Terraform Scripts

#### main.tf

* **null_resource "Nginx-setup"**: This resource performs the following actions:
  * `Triggers`: Sets up triggers based on the hash of the Kubernetes cluster nodes' private IP list and the public domain list.
  * `Connection`: Defines the SSH connection parameters for the EC2 instance.
  * `File Provisioner`: Uploads the nginx-setup.sh script to the EC2 instance.
  * `Remote Exec Provisioner`: Executes the necessary commands to:
  * Set environment variables.
  * Run the nginx-setup.sh script.

#### nginx-setup.sh: 
This script performs the following actions:
  * Logs the script execution.
  * Installs Nginx and SSL dependencies.
  * Obtains SSL certificates using Certbot.
  * Enables and starts the Nginx service.
  * Clones the specified Kubernetes infrastructure repository and runs the Nginx setup script from it.
