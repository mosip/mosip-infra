
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
Change the path of the keys to this directory.

* Obtain an Elastic IP from AWS.

* terraform apply -target aws_route53_record.kube -target aws_route53_record.console



