# Fetch variables via ENV variables

```
$ export TF_VAR_CLUSTER_NAME=dev
$ export TF_LOG="DEBUG"
$ export TF_LOG_PATH="/tmp/terraform.log"
```

* TF_VAR_ : is a syntax 
* CLUSTER_NAME=dev : is variable and its value


# Terraform Setup for MOSIP Infrastructure

## Overview
This Terraform configuration script set up the infrastructure for MOSIP (Modular Open Source Identity Platform) on AWS.
The setup includes security groups, an NGINX server, and a Kubernetes (K8S) cluster.

## Requirements
* Terraform version: `v1.8.4`
* AWS Account
* AWS CLI configured with appropriate credentials
  ```
  $ export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
  $ export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
  $ export TF_VAR_SSH_PRIVATE_KEY=<EC2_SSH_PRIVATE_KEY>
  ```

## Files
* `main.tf`: Main Terraform script that defines providers, resources, and output values.
* `variables.tf`: Defines variables used in the Terraform scripts.
* `outputs.tf`: Provides the output values.
* `locals.tf`: Defines a local variable `SECURITY_GROUP` containing configuration parameters required for setting up security groups for Nginx and Kubernetes cluster nodes.

## Setup
* Initialize Terraform.
  ```
  terraform init
  ```
* Review and modify variable values:
    * Ensure `locals.tf` contains correct values for your setup.
    * Update values in `env.tfvars` as per your organization requirement.
    * Verify `variables.tf` for any additional configuration needs.
* Terraform validate & plan the terraform scripts:
  ```
  terraform validate
  ```
  ```
  terraform plan -var-file="./env.tfvars
  ```
* Apply the Terraform configuration:
  ```
  terraform apply -var-file="./env.tfvars
  ```

## Destroy
To destroy AWS resources, follow the steps below:
* Ensure to have `terraform.tfstate` file.
  ```
  terraform destroy -var-file=./env.tfvars
  ```

## Modules

#### aws-resource-creation
This module is responsible for creating the AWS resources needed for the MOSIP platform, including security groups, an NGINX server, and a Kubernetes cluster nodes.

* Inputs:
  * `CLUSTER_NAME`: The name of the Kubernetes cluster.
  * `AWS_PROVIDER_REGION`: The AWS region for resource creation.
  * `SSH_KEY_NAME`: The name of the SSH key for accessing instances.
  * `K8S_INSTANCE_TYPE`: The instance type for Kubernetes nodes.
  * `NGINX_INSTANCE_TYPE`: The instance type for the NGINX server.
  * `MOSIP_DOMAIN`: The domain name for the MOSIP platform.
  * `ZONE_ID`: The Route 53 hosted zone ID.
  * `AMI`: The Amazon Machine Image ID for the instances.
  * `SECURITY_GROUP`: Security group configurations.

#### nginx-setup
This module sets up NGINX and configures it with the provided domain and SSL certificates.

* Inputs:
  * `NGINX_PUBLIC_IP`: The public IP address of the NGINX server.
  * `MOSIP_DOMAIN`: The domain name for the MOSIP platform.
  * `MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST`: List of private IP addresses of the Kubernetes nodes.
  * `MOSIP_PUBLIC_DOMAIN_LIST`: List of public domain names.
  * `CERTBOT_EMAIL`: The email ID for SSL certificate generation.
  * `SSH_KEY_NAME`: SSH private key used for login (i.e., file content of SSH pem key).

## Outputs
The following outputs are provided:

* `K8S_CLUSTER_PUBLIC_IPS`: The public IP addresses of the Kubernetes cluster nodes.
* `K8S_CLUSTER_PRIVATE_IPS`: The private IP addresses of the Kubernetes cluster nodes.
* `NGINX_PUBLIC_IP`: The public IP address of the NGINX server.
* `NGINX_PRIVATE_IP`: The private IP address of the NGINX server.
* `MOSIP_NGINX_SG_ID`: The security group ID for the NGINX server.
* `MOSIP_K8S_SG_ID`: The security group ID for the Kubernetes cluster.
* `MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST`: The private IP addresses of the Kubernetes cluster nodes.
* `MOSIP_PUBLIC_DOMAIN_LIST`: The public domain names.
