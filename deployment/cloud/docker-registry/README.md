We have setup and configured a private docker registry, which will be basic authenticated, SSL secured. In our setup we are using azure blobs as storage for our docker images. More options for configuring registry can be found [here](https://docs.docker.com/registry/configuration/)
We are deploying Docker registry as Containerized services. For setting up the registry, [Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) need to be installed. We have setted up the registry in a machine with Redhat 7.5 installed.<br/>
Once installation is done, the yaml files which we will be using to setup the registry can be found under scripts/docker-registry folder in the source code.
We are using Registry image : registry:2.5.1, registry with any other version can be deployed from [here](https://hub.docker.com/_/registry). <br/>For routing purpose, we are using HAproxy image dockercloud/haproxy:1.6.2, other options such as ngnix etc. can also be used for the same purpose.<br/>
We have the following docker-compose files, under scripts/docker-registry folder:<br/>
1. **registry-docker-compose.yml:**  For basic registry and haproxy setup.
2. **registry-docker-compose-basic-authentication.yml:**  For securing the docker registry through base authentication.
For basic authentication, you have to setup a htpasswd file and add a simple user to it. For generating this htpaswd file:<br/>
  * Create Htpasswd_dir directory<br/>
`mkdir -p ~/htpasswd_dir`<br/>
  * Create htpasswd file with your username and password<br/>
 `docker run --rm --entrypoint htpasswd registry:2 -Bbn <username> "<password>" > ~/htpassword_dir/htpasswd`<br/>
  * In the registry-docker-compose-basic-authentication.yml file, replace <YOUR-REALM-NAME> and <YOUR-HTPASSWD-PATH> with 
    specific values.
     
3. **registry-docker-compose-azure-storage.yml:**  This file is used for configuring azure blob storage. We are assuming that Azure blob has already been configured by you. Replace REGISTRY_STORAGE_AZURE_ACCOUNTNAME, REGISTRY_STORAGE_AZURE_ACCOUNTKEY, REGISTRY_STORAGE_AZURE_CONTAINER with appropriate values configured by you while setting up azure blob storage.
4. **registry-docker-compose-tls-enabled.yml:**  We are using **Let's Encrypt**, CA signed SSL certificates. Documentation of Let's Encrypt can be referred [here](https://letsencrypt.org/getting-started/)
  Once Certificates have been generated, replace the <REGISTRY_HTTP_TLS_CERTIFICATE> property and <REGISTRY_HTTP_TLS_KEY> property in registry-docker-compose-tls-enabled.yml with appropriate values.
After completing all the above changes, use docker-compose tool to bring up the container using the following command:<br/>
`docker-compose -f registry-docker-compose.yml -f registry-docker-compose-basic-authentication.yml -f registry-docker-compose-azure-storage.yml -f registry-docker-compose-tls-enabled.yml  up -d`<br/>
Once the registry is up and running, variables **registryUrl**, **registryName**, **registryCredentials** can be configured accordingly in Jenkinsfile.<br/> For configuring registry Credentials in Jenkins, Username/Password credentials need to be added in Jenkins Global Credentials and credential ID needs to be provided in **registryCredentials** variable in all the Jenkinsfiles.
