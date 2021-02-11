## Troubleshooting

If you already have a previous version of docker on console, it the new docker may not get installed properly.  Clean the existing installation as below:

```
$ sudo yum remove docker-*
$ sudo rm -rf /var/lib/docker
```
If `rm` fails do the following:

```
$ cat /proc/mounts | grep docker
$ sudo umount <paths>
$ sudo rm -rf /var/lib/docker
```


