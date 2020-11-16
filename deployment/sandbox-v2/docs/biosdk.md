# BioSDK integration 

The biosdk library is used in reg client, reg proc and ida.  The guide here provides steps to enable these integrations.

## Integration with IDA 

For IDA, biosdk is expected to be available as an HTTP service.  This service is then called by ID Authentication module.  Refer to the [reference implementation](https://github.com/mosip/mosip-ref-impl/tree/1.1.3/sdk) to create such a service.  Here `/service` contains code for the service while `/client` contains code for the client that is integrated with IDA that connects to this service.  The client code is available as part of mosip IDA dockers - you do not need to change the same.  

In `service/Dockerfile` you will see that biosdk jar (assumed self-contained) is fetched and baked into the docker. 

This service may run inside the Kubernetes cluster as a pod or hosted outside the cluster.

## Integration with Reg Proc

The above service works for regproc as well. 
