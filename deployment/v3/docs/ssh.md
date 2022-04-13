# Passwordless SSH

For passwordless SSH access to remote machines, set up keys as follows:
* Generate keys on your working machine/laptop:
```
ssh-keygen -t rsa
```
* Copy the keys to remote machines: 
```
ssh-copy-id <remote-user>@<remote-ip>
```
* SSH into the node to check password-less SSH: 
```
ssh -i ~./ssh/<your private key> <remote-user>@<remote-ip>
```
