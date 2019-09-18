# MOSIP Developer Installer

The scripts here enable a developer to run MOSIP modules on a single machine with very low memory configuration.  The module Jars are run directly without any containerization.  

## Running the Installer

1. This Installer runs on CenOS 7. Create a new VM with CentOS 7. The installer was tested with CentOS-7-x86_64-DVD-1810.iso with 2 CPU, 8GB RAM, 40GB storage configuration.
1. Make sure network is enabled on the VM.
1. Create a new user. Login as this user.
1. Add current user to `/etc/sudoers` file.     
1. Install git:  
`$ sudo yum install -y git`
1. Create `mosip` directory in home directory.
1. `$ cd $HOME/mosip`
1. Clone this repo:    
`$ git clone https://github.com/mosip/mosip-infra.git`  
1. Install prerequisties (Python3.6 etc):  
`$ cd deployment/developer`  
`$ sh prerequisites.sh`  
1. Logout, and login again as the same user.
1. Modify `config_server/mosip_configs/kernel.properties` to add your Gmail account SMTP credentials in the following fields:    
`spring.mail.username=<user email id>`   
 `spring.mail.password=<password>`
1. Modify `config_server/mosip_configs/registration-processor.properties` to add your login user id here:
`registration.processor.dmz.server.user=<your login id>`
1. `$ cd $HOME/mosip` 
1. Clone `mosip-platform` repo:  
`$ git clone https://github.com/mosip/mosip-platform.git`    
`$ cd mosip-platform`  
`$ git checkout 0.9.0_a`  
1. Run installer as below (do **not** run with `sudo`):  
`$ cd $HOME/mosip/mosip-infra/deployment/developer/launcher`  
`$ ./launcher --help`  
`$ ./launcher --install-environ` (one time)  
`$ ./launcher --build-code`  
`$ ./launcher --start-services`  
1. Monitor the logs under `launcher/logs` dir for any errors.  
`$ grep ERROR *`
1. Once all services are up, run a test api under `launcher/test/api_test.py` (inspect and modify the API parameters before running). For the OTP email test, you will have to allow Google to receive emails from apps (lesser security setting).  
`$ cd launcher/test/`  
`$ python3.6 api_test.py`  

## LDAP UI tool
- For inspecting contents of LDAP, download and install Apache Studio DS
http://directory.apache.org/studio/download/download-linux.html
- Create a new connection with following params: host = localhost, port = 10389, Simple Authentication, Bind DN = "uid=admin,ou=system", Bind password = "secret"

## Notes
* config server runs on port 8888 by default.  It may conflict with some services. TODO: Change the port.
* HDFS secure authentication is disabled, hence Kerberos is not used. 
* For local run all ports have to be different. In the above branch of mosip-platform code, all kernel ports have been changed to 81xx.
* HTTPS connections have been changed to HTTP connection in code.
* Detailed logs have been redirected by changing code (path was hardcoded)
* To run a particular jar (for debugging etc):  
`java -Dspring.cloud.config.uri=http://localhost:8888 -Dspring.cloud.config.label=master -Dspring.profiles.active=dev -Xmx256m -jar <jar_path> >> <log_path> 2>&1 &`
* Digital signature has been disabled in `registration-processor.properties`.  Enable it later.  
`registration.processor.signature.isEnabled=false` 
* Following change has been made in the `mosip-platform` code in `ConnectionUtils.java` to make HDFS work in single node docker mode:  
`configuration.set("dfs.client.use.datanode.hostname", "false");`

## License
This project is licensed under the terms of [Mozilla Public License 2.0](https://github.com/mosip/mosip-infra/blob/master/LICENSE)

