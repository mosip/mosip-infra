# S3 Credentials

## Credentials
1. Create a new IAM user on AWS, say, "mosips3user"
1. Deny this user Admin Console access
1. Create a user group, say, 'S3Group' with full access to S3. 
1. Assign the group to the user 

## Secrets
1. Create configmap and secrets by running this script:
```sh
cd ../
./cred.sh
```
