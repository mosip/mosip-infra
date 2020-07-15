## Install MOSIP Sandbox on AWS using Terraform

1. Install latest version of terraform. 

1. Set the following environment variables:
    ```
    export AWS_ACCESS_KEY_ID=<>
    export AWS_SECRET_ACCESS_KEY=<>
    export TF_LOG=DEBUG
    export TF_LOG_PATH=tf.log  
    ```
1. Generate RSA key pairs in this folder with default names `id_rsa` and `id_rsa.pub`:
    ```
    $ ssh-keygen -r rsa
    ```
1. Modify the variables in `variables.tf` as per your setup. 

1. Obtain a domain name for the sandbox, example, `mosip.net`.   

1. Run terraform:
    ```
    $ terraform plan
    $ terraform apply
    ```
1. Assign a subdomain like `qa.mosip.net` to point to public IP address ('A') of console machine on AWS Route53 Console.  Use this subdomain as sandbox domain name in Ansible scripts.

1. To create multiple such sandboxes, copy the contents of this folder into another folder, say, `sandbox2`, `cd` to the folder and carry out the above steps. 


