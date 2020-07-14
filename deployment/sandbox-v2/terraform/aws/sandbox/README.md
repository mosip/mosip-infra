## Install MOSIP Sandbox on AWS using Terraform

1. Install latest version of terraform. 

1. Set the following environment variables:
    ```
    export AWS_ACCESS_KEY_ID=<>
    export AWS_SECRET_ACCESS_KEY=<>
    export TF_LOG=DEBUG
    export TF_LOG_PATH=tf.log  
    ```
1. Generate RSA key pairs in this folder
    ```
    $ ssh-keygen -r rsa
    ```
Save the keys to this directory with default names `id_rsa` and `id_rsa.pub`.

1. Modify the variables in `variables.tf` as per your setup. 

1. Obtain an Elastic IP (EIP) from AWS.

1. Obtain a domain name for the sandbox, example, `qa-sandbox-mosip.net`.   

1. Point the domain name to the EIP. 

1. Run terraform:
    ```
    $ terraform plan
    $ terraform apply
    ```
1. Assign EIP to instance `console` using AWS administration console.

1. To create multiple such sandboxes, copy the contents of this folder into another folder, say, `sandbox2`, `cd` to the folder and carry out the above steps. 


