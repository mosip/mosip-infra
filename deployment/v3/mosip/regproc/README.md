# Registration processor services

## Prerequisites
Install Kafka as given [here](kafka/README.md)

## Install
```
$ kubectl create namespace regproc
$ ./copy_cm.sh
$ helm repo update
$ ./install_all.sh 
```
## To stop all modules
```
$ ./delete_all.sh
```

