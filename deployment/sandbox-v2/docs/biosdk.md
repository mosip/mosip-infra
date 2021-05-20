# BioSDK integration 

The biosdk library is used in reg client, reg proc and ida.  The guide here provides steps to enable these integrations.

## Integration with IDA 

For IDA, biosdk is expected to be available as an HTTP service.  This service is then called by ID Authentication module.  Refer to the [reference implementation](https://github.com/mosip/mosip-ref-impl/tree/develop) create such a service.  Here `biosdk-service` contains code for the service while `/biosdk-client` contains code for the client that is integrated with IDA that connects to this service.  This service may run inside the Kubernetes cluster as a pod or hosted outside the cluster.

The client code needs to be compiled into a `biosdk.zip` and copied to the Artifactory. Currently, it is available here: `/artifactory/libs-release-local/biosdk/mock/0.9/biosdk.zip` for mock. IDA dockers download this zip and install during docker startup.

## Integration with Reg Proc

The above service works for regproc as well. 


Real SDK intagration

As of now in sandbox installation we are using mock-biosdk-service .. but in country implementation we need to get the real biosdk service up and running in two possible ways:
	
	* Passing the real sdk jar to the existing biosdk service running in the cluster using below mentioned environment variable:
		`biosdk_zip_url  -- path of the sdk jar to download`
		`biosdk_bioapi_impl  -- classpath to be included in service`

	* Pointing to the real sdk service runnning somewhere outside the cluster by making change in below mentioned parameters:
		`biosdk_service_url in mosip-infra/deployments/sandboxv2/group_vars/all.yml `
		updating param: `mosip.biosdk.default.host` in below mentioned properties file
		```
		id-authentication-mz.properties
		id-repository-mz.properties
		registration-processor-mz.properties
		```
