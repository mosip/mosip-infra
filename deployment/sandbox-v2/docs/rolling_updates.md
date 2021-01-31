# Rolling Updates

## Introduction

To update the version of an image or rollback to previous working version, there is a rolling update strategy implemented across all modules to provide this feature without any downtime of the service at client end.  

## Update an image

  - Check the current version of image in pod using ``` $ kc1 get pods <pod-name> ```, the **image** field in description contains the image name with current version.  
  - To update the image of application to next version, use the **set image** command as per mentioned below:  
	```
	$ kc1 set image deployments/<dep-name> <container-name>=<image-name>:<version>
	```  
    example:  
	```
	$ kc1 set image deployments/test_version_update test=nginx:1.18.0
	```  
    (deployment name: test_version_update, container name: test, image: nginx, new version- 1.18.0)

## Verify an update

  - To verify the updated image of application, use the "status" command as per mentioned below:  
	```
	$ kc1 rollout status deployments/<dep-name>
	```  
    example: 
	```
	$ kc1 rollout status deployments/test_version_update
	```

## Rollback an update

  - Check the status of deployment using ```$ kc1 get deployments/<dep-name>``` to check number of pods running.  
  - List the pods using ```$ kc1 get pods```, if any pod has status of "ImagePullBackOff", then version of image must be rolled back to previous version.  
  - To rollback the image of application to previous version, use the **undo** command as per mentioned below:
	```
	$ kc1 rollout undo deployments/<dep-name>
	```
    example:  
	```
	$ kc1 rollout undo deployments/test_version_update
	```  
  - List the pods again to verify rollback.
