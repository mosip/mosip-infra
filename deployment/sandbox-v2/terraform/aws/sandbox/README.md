## Provisioning of AWS resources for MOSIP Sandbox using Terraform

### Domain name 
1. Obtain a domain name for the sandbox using AWS Route53, example, `mosip.net`.  This is required to access sandbox externally.

### Terraform setup
1. Install latest version of terraform. 

1. Set the following environment variables:
    ```
    export AWS_ACCESS_KEY_ID=<>
    export AWS_SECRET_ACCESS_KEY=<>
    export TF_LOG=DEBUG
    export TF_LOG_PATH=tf.log  
    ```
### Keys
1. On AWS EC2 admin console generate a key pair called `mosip-aws`.  Download the private key `mosip-aws.pem` to your local `~/.ssh` folder. Make sure the permission of `~/.ssh/mosip-aws.pem` is set to 600. 

1. Generate a new set of RSA key pairs with default names `id_rsa` and `id_rsa.pub` and place them in current folder. Do not give any passphrase. These keys are exchanged between sandbox console and cluster machines.
    ```
    $ ssh-keygen -t rsa -f ./id_rsa
    ```
### DNS
1. If you would like to use the default private DNS installed as part of default sandbox install, then skip this step. To use AWS Route53 DNS for resolving names of all machines uncommment the code in `terraform/aws/sandbox`.
  
1. If you have different number of machines in your setup, udpdate `variables.tf`. Make sure the IP addresses assigned match the ones in `hosts.ini` file of Ansible setup.
  
### Sandbox name
1. Modify `sandbox_name` in `variables.tf` as per your setup.  The name here is informational and will be added as tag to the instance.  It is recommended this name matches subdomain name for easy reference (see below).  Example, `sandbox_name` is `staging` and subdomain is `staging.mosip.net`. 

### Performance testing
1. If you are doing performance testing and prefer higher IOPS SSD on sandbox console, modify `iops` and `volume_type` in `console.tf`. Example:
    ```
    ebs_block_device  { 
      device_name = "/dev/sdf"
      iops = 3000
      volume_type = "io1"
      volume_size = 128
      delete_on_termination = true 
    } 
    ```

### Other variables
There are other variables, do not modify them unless you have a good understanding of the scripts and their impact on Ansible scripts. 

### Install

1. Run terraform:
    ```
    $ terraform init # One time
    $ terraform plan
    $ terraform apply
    ```
1. Open the "Hosted Zones" on AWS admin console. Your domain name (e.g. `mosip.net`) should be listed there.  Assign a subdomain like `qa.mosip.net` to point to public IP address ('A') of sandbox console machine on AWS Route53 Console.  Use this subdomain as `sandbox_domain_name` in Ansible scripts.

### Multiple sandboxes
1. To create multiple such sandboxes, copy the contents of this folder into another folder, say, `sandbox2`, `cd` to the folder and carry out the above steps. CAUTION: Before you start running the scripts make sure the copied folder (current folder) does not have any Terraform state files from some other installation (delete them if present).

### Useful tips
* On AWS admin console, on "instances" page, enable column "component".  You will able to associate instance to the sandbox in case you have multiple boxes running. 

