* Install latest version of terraform. 

* Set the following environment variables:

```
export AWS_ACCESS_KEY_ID=<>
export AWS_SECRET_ACCESS_KEY=<>
export TF_LOG=DEBUG
export TF_LOG_PATH=tf.log  
```

* Generate RSA key pairs in current repo:
```
$ ssh-keygen -r rsa
```
Save the keys to this directory with default names `id_rsa` and `id_rsa.pub`.

* Obtain an Elastic IP from AWS.

* Obtain a domain name for sanbox, example, `qa-sandbox-mosip.net`.

* Point the domain name to the elastic IP.

* Run terraform:
```
$ terraform plan
$ terraform apply
```
* Assign elastic IP (EIP) to console using administration console.


