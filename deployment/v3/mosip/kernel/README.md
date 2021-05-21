# Kernel modules

Instructions here apply to all Kernel modules. 

## Install 
1. Copy configurations from other namespaces (once for kernel namespace)
```
./copy_cm.sh
```
1. Install specific kernel module
```
$ helm repo update
$ helm -n kernel install <module> mosip/module -f values.yaml
```
`values.yaml` is needed only when you have specific changes to original values.



