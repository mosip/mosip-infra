# Procedure to be followed while performing below steps

1. DB change, keycloak restart services.
2. Restart of all the services.
3. Restart of specific services.
4. Manual reprocess
5. Modification of Reprocessor config
6. Rollout restarts

## DB change, keycloak restart services.

* When we add any new db , we have to follow below steps:

1. Update all database parameters in postgres-init/values.yaml (https://github.com/mosip/mosip-helm/blob/develop/charts/postgres-init/values.yaml)
![](/home/techno-243/Pictures/img1.png)
2. We need to add configmap.yaml and job.yaml file for the particular db in the templates section of postgres_init (https://github.com/mosip/mosip-helm/tree/develop/charts/postgres-init/templates)
![](/home/techno-243/Pictures/img2.png)
3. we need to clone the particular github repo to local , then set the following environment variables
![](/home/techno-243/Pictures/img3.png)
4. After setting up all these values in the respective folder of github repo cloned
5. Run the following command to deploy the db in pgadmin
   * bash deploy.sh deploy.properties
![](/home/techno-243/Pictures/img4.png)
6. The db will be created in pgadmin for the specific environment needed


## Restart of all the services

* If we want to restart of all the services in rancher, we have to make sure below points:

1. First namespace should be correct
2. We need to check whether we are in pod section or not, we have to be in pod section
![](/home/techno-243/Pictures/img5.png)
3. To restart of all services, we have to basically just select state checkbox and  it will ask for confirmation then we can click on delete
![](/home/techno-243/Pictures/img6.png)
4. Restart sequence of MOSIP services (https://github.com/mosip/mosip-infra/blob/develop/deployment/v3/docs/restart-sequence.md)

* If we want  to try with our local system, we have to make sure below points:

1. We have to download cluster config file from rancher
2. We have to set our kubeconfig for which environment we need to restart all the services using below command
   * cp <yaml.file> config
3. We want to check whether kubeconfig pointing to correct cluster or not using below command
Kubectl config view
![](/home/techno-243/Pictures/img7.png)
4. To restart of all the services, use the following commands
   * helm -n <ns> list
   * helm -n <ns> delete <service_names>



## Restart of specific services:

* If we want to restart of specific services in rancher, we have to make sure below points:
 
1. First namespace should be correct
2. We need to check whether we are in pod section or not, we have to be in pod section
![](/home/techno-243/Pictures/img1.png)
3.  To restart of specific services, we have to select specific service, click on delete   and  it will ask for confirmation then we can click on delete
![](/home/techno-243/Pictures/img8.png)


## Manual reprocess


## Modification of Reprocessor config



## Rollout restarts

For rolling out a restart, use the following command:

* kubectl rollout restart pod <pod_name>











