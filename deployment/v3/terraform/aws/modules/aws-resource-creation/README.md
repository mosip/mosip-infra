# Terraform Script for AWS Infrastructure with Certbot and NGINX

## Overview
This Terraform script sets up an AWS infrastructure that includes:

* IAM roles and policies for Certbot to modify Route 53 DNS records.
* Security groups for NGINX and Kubernetes instances.
* EC2 instances for NGINX and Kubernetes.
* Route 53 DNS records for managing domain names.
* Certbot for SSL certificate generation.

## Requirements

* Terraform version: `v1.8.4`
* AWS Account
* AWS CLI configured with appropriate credentials
  ```
  $ export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
  $ export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
  ```
* Ensure SSH key created for accessing EC2 instances on AWS.

## Files
* `certbot-ssl-certgen.tf`: Defines IAM roles, policies, and instance profiles for Certbot.
* `aws.tfvars`: Contains variable values for AWS infrastructure configuration.
* `main.tf`: Main Terraform script that defines providers, resources, and output values.
* `variables.tf`: Defines variables used in the Terraform scripts.

## Setup
* Initialize Terraform
  ```
  terraform init
  ```
* Review and modify variable values:
  * Ensure `aws.tfvars` contains correct values for your setup.
  * Verify `variables.tf` for any additional configuration needs.
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

## Terraform Scripts

#### certbot-ssl-certgen.tf
* Defines resources for setting up IAM roles and policies for Certbot:
  * `aws_iam_role.certbot_role`: IAM role for Certbot with EC2 assume role policy.
  * `aws_iam_policy.certbot_policy`: IAM policy allowing Certbot to modify Route 53 records.
  * `aws_iam_role_policy_attachment.certbot_policy_attachment`: Attaches the policy to the role.
  * `aws_iam_instance_profile.certbot_profile`: Creates an instance profile for the IAM role.

#### aws.tfvars
* Contains configuration variables for the AWS infrastructure
* Ensure the AMI ID `ami-xxxxxxxxxxxxxxxxx` is available in your specified region.
* The `user_data` script for the NGINX instance mounts an EBS volume at `/srv/nfs`.
* Modify the security group rules as per your security requirements.

#### main.tf
* Defines the main resources and provider configuration:
  * `Providers`: AWS provider configuration.
  * `Security Groups`: aws_security_group.security-group for NGINX and Kubernetes.
  * `EC2 Instances`:
    * **aws_instance.NGINX_EC2_INSTANCE** for NGINX.
    * **aws_instance.K8S_CLUSTER_EC2_INSTANCE** for Kubernetes.
  * `Route 53 Records`:
    * **aws_route53_record.MAP_DNS_TO_IP** for A records.
    * **aws_route53_record.MAP_DNS_TO_CNAME** for CNAME records.

#### outputs.tf
* Provides useful information after infrastructure creation.

#### variables.tf
* Defines input variables used across the Terraform scripts

#### Outputs
The script provides the following output values:

* `K8S_CLUSTER_PUBLIC_IPS`: Public IPs of Kubernetes cluster nodes.
* `K8S_CLUSTER_PRIVATE_IPS`: Private IPs of Kubernetes cluster nodes.
* `NGINX_PUBLIC_IP`: Public IP of the NGINX instance.
* `NGINX_PRIVATE_IP`: Private IP of the NGINX instance.
* `MOSIP_NGINX_SG_ID`: Security group ID for NGINX.
* `MOSIP_K8S_SG_ID`: Security group ID for Kubernetes.
* `MOSIP_K8S_CLUSTER_NODES_PRIVATE_IP_LIST`: Comma-separated list of Kubernetes cluster nodes private IPs which will be used by Nginx terraform scripts.
* `MOSIP_PUBLIC_DOMAIN_LIST`: Comma-separated list of public domains configured in Route 53 which will be used by Nginx terraform scripts.
