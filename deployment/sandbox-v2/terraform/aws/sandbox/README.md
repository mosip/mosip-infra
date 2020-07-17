## Install MOSIP Sandbox on AWS using Terraform

### Setup
1. Obtain a domain name for the sandbox using AWS Route53, example, `mosip.net`.  This is required to access sandbox externally.

1. Install latest version of terraform. 

1. Set the following environment variables:
    ```
    export AWS_ACCESS_KEY_ID=<>
    export AWS_SECRET_ACCESS_KEY=<>
    export TF_LOG=DEBUG
    export TF_LOG_PATH=tf.log  
    ```
1. On AWS EC2 console generate a key pair called `mosip-aws`.  Download the private key `mosip-aws.pem` into your local ~/.ssh folder. Make sure the permission of `~/.ssh/mosip-aws.pem` is set to 600.  Spec

1. Generate a new set of RSA key pairs with default names `id_rsa` and `id_rsa.pub` and place them in current folder. Do not give any passphrase. These keys are exchanged between sandbox console and cluster machines.
    ```
    $ ssh-keygen -t rsa -f ./id_rsa
    ```
1. Modify `sandbox_name` in `variables.tf` as per your setup.  There are other variables, do not modify them unless you have a good understanding of the scripts and their impact on Ansible scripts. 

### Install

1. Run terraform:
    ```
    $ terraform init # One time
    $ terraform plan
    $ terraform apply
    ```
1. Open the "Hosted Zones" console of AWS. Your domain name (e.g. `mosip.net`) should be listed there.  Assign a subdomain like `qa.mosip.net` to point to public IP address ('A') of console machine on AWS Route53 Console.  Use this subdomain as sandbox domain name in Ansible scripts.

### Multiple sandboxes
1. To create multiple such sandboxes, copy the contents of this folder into another folder, say, `sandbox2`, `cd` to the folder and carry out the above steps. 

### Useful tips
* On AWS console, on "instances" page, enable column "component".  You will able to associate instance to the sandbox in case you have multiple boxes running. 

