# MOSIP Sandbox Deployer

MOSIP Sandbox deployer enables anyone to build and deploy MOSIP on a single machine (with Linux OS). As we use pre-crafted docker images, we can quickly setup MOSIP and use it for demonstration.

**THIS IS NOT FOR PRODUCTION DEPLOYMENTS**

## Overview
![](images/sandbox-overview.png)

## Pre-requisites
* **OS:** Ubuntu 18.0.4 LTS
* **Hardware:**
  * For Running Kernel and Pre Registration, we need, 4 core CPU with 32 GB RAM and about 80 GB of free hard disk space.
  * For Running Kernel, Registration Processor and ID Repo, we need, 8 core CPU with 56 GB RAM and about 80 GB of free hard disk space.
* **Tools:** Install `curl` and `git`
      
## Get, Set, Go!
1. Clone this repository.
   ```
   $ git clone https://github.com/mosip/mosip-infra
   ```
1. Edit `mosip-infra/deployment/sandbox/playbooks-properties/all-playbooks.properties` with appropriate values (change only properties marked as `<ToBeReplaced\>`).

   Below is a sample example for key-value pair of the playbook properties.
   ```
   spring.mail.username=xxx@gmail.com
   spring.mail.password=xxxpwd
   spring.mail.host=smtp.gmail.com
   spring.mail.port=587
   mosip.kernel.sms.gateway=SMSgatewayProviderName
   mosip.kernel.sms.api=https://SMSGatewayHostName/sms/2/text/single
   mosip.kernel.sms.username=<registered username with SMS gateway provider>
   mosip.kernel.sms.password=<registered password>
   mosip.kernel.sms.sender=<SMS Sender name, can be any name>
   ```
   **_Note:_** If you do not have a SMS service provider, you can replace the configurations related to SMS (i.e. gateway, api, username, password and sender) with dummy values.
    
1. Go to 'sandbox' directory.
   ```
   $ cd mosip-infra/deployment/sandbox/
   ````
1. Go to root.
   ```
   $ sudo su
   ```
**_Note:_** This is a major step before installing anything. You have to execute all the remaining steps as a root user.

### MOSIP Kernel
1. Make sure that, you are the root user.
1. Install the kernel module by executing the below command. This is the base for all other modules.
    ```
    $ sh install-mosip-kernel.sh
    ```
1. Check for errors in `install-mosip-sandbox.log`. Go to the last line and check for `failed=0` which indicates that there are no failures during the deployment.

1. If there are no errors in the log, wait for about 5 minutes for the kernel services to be up and running. 

### MOSIP Pre-registration 
1. Make sure that, you are the root user.
1. Install the pre-registration module by executing the below command.
    ```
    $ sh install-mosip-pre-reg.sh
    ```    
1. Check for errors in `install-mosip-sandbox.log`. Go to the last line and check for `failed=0` which indicates that there are no failures during the deployment.

1. If there are no errors in the log, wait for about 10 minutes for the pre-registration services to be up and running.

#### Steps to access the Pre-registration UI    
1. MOSIP Pre-registration UI can be accessed using the url `http://<public_ip_address>/pre-registration-ui`
    * **_Note_**:  To find the public ip address of your  machine, you may use the following command: `$ curl ifconfig.me`.    
	* Below is the screenshot of the Pre-registration startup page.
	
![](images/pre-reg-screenshot.png)

1. Login into the Pre-registration portal using OTP sent to email or phone.

### MOSIP Registration Processor
1. Make sure that, you are the root user.
1. Install the registration processor module by executing the below command.
    ```
    $ sh install-mosip-reg-proc.sh
    ```    
1. Check for errors in `install-mosip-sandbox.log`. Go to the last line and check for `failed=0` which indicates that there are no failures during the deployment.

1. If there are no errors in the log, wait for about 10 minutes for the registration-processor services to be up and running.

  **_Note:_**  If the internet connection is slow, you might face deployment failure for Registration Processor Services. In such a case, you can re-run the `install-mosip-reg-proc.sh` command.

1. If there are no errors in the log, wait for about 10 minutes for the Reg Proc services to be up and running. 

#### Steps to upload a packet into Reg Proc
1. Run the test script for Reg Proc.
     ```
     $ sh testing-upload-packet-registration-processor.sh
     ```   
1. Through Postman, perform post operation on the below URL,

      **_Note:_** _Replace <public_ip_address> with the public IP of your machine._
      ```
      http://<public_ip_address>/v1/utility/packetgenerator/createAndUpload
      ```
    
   and provide the below json data in the body.

      **_Note:_**  _Replace email in the below body with your email id._
```
     {
        "id": "io.mosip.packetgenerator.uploader",
        "request": {
             "firstName": "Foo",
             "lastName": "User",
	     "gender": "Male",
	     "dateOfBirth": "1993/02/20",
	     "age": 26,
	     "phone": "8144203333",
 	     "email": "youremailid@domain",
 	     "addressLine1": "string",
	     "addressLine2": "string",
	     "addressLine3": "string"
	     },
        "requesttime": "2020-02-11T14:07:03.134Z",
        "version": "v1"
     }
```
   ### You will get a response like this
```
     {
        "id": "io.mosip.packetgenerator.uploader",
        "version": "v1",
        "responsetime": "2020-03-30T18:28:47.150Z",
        "metadata": null,
        "errors": null,
        "response": {
            "registartionId": "10002100320000220200330182847",
            "status": "packet has been created and uploaded"
         }
     }
```

Hence, your packet has been successfully created and uploaded. Once all the stages of Reg Proc are passed, you will get a confirmation mail on the email id you provided in the body.
 

