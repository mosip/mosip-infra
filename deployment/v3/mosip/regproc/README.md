# Registration processor services

## Prerequisites
* Install Kafka as given [here](../../external/kafka/README.md)
* Create websub topics:
```sh
cd topic
./create_topics.sh
```

## Install
```
$ ./install.sh
```
## To delete all modules
```
$ ./delete.sh
```
## Stage groupings

### stage-group-1

* registration-processor-packet-receiver-stage

### stage-group-2
* registration-processor-quality-classifier-stage
* registration-processor-securezone-notification-stage
* registration-processor-message-sender-stage

### stage-group-3
* registration-processor-abis-handler-stage
* registration-processor-abis-middleware-stage
* registration-processor-bio-dedupe-stage
* registration-processor-manual-verification-stage

### stage-group-4
* registration-processor-biometric-authentication-stage
* registration-processor-demo-dedupe-stage

### stage-group-5
* registration-processor-cmd-validator-stage
* registration-processor-operator-validator-stage
* registration-processor-supervisor-validator-stage
* registration-processor-introducer-validator-stage
* registration-processor-packet-validator-stage

### stage-group-6
* registration-processor-packet-uploader-stage
* registration-processor-packet-classifier-stage

### stage-group-7
* registration-processor-uin-generator-stage
* registration-processor-printing-stage
