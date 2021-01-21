# Test Registration Client with Mock MDS and Mock SDK

## Download Reg Client
  * Download zip file from:
    ```
    https://<sandbox domain name>/registration-client/1.1.3/reg-client.zip
    ```
  * Unzip the file and launch reg client by running `run.bat`.
  * Reg client will generate public/private keys in the following folder 
    ```
    c:\Users\<user name>\.mosipkeys\ 
    ```
  * You will need the public key and key index mentioned in `readme.txt` for the later step to update master db.

## Run MDS
  * Run mock MDS as per procedure give here: [Mock MDS](https://github.com/mosip/mosip-mock-services/tree/master/MockMDS) 
  * Pickup device details from this repo. You will need them for device info updates in the later step.

## Add users in Keycloak
  * Make sure keycloak admin credentials are updated in `config.py`
  * Add users like registration officers and supervisors in `csv/keycloak_users.csv` with their roles.
  * Run 
    ```
    $ ./keycloak_users.py
    ```

## Update masterdata 
  * Update the following CSVs in master db DML directory.  On sandbox the DMLs are located at `/home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/commons/db_scripts/mosip_master/dml`.
    * `master-device_type.csv`
    * `master-device_spec.csv`
    * `master-device_master.csv`    
    * `master-device_master_h.csv`    
    * `master-machine_master.csv`
    * `master-machine_master_h.csv`
    * `master-user_detail.csv` 
    * `master-user_detail_h.csv` 
    * `master-zone_user.csv`
    * `master-zone_user_h.csv`
  * Run `update_masterdb.sh`. Example:
    ```
    $ ./update_masterdb.sh /home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/commons/db_scripts/mosip_master
    ```
  * CAUTION: The above will reset entire DB and load it fresh.  
  * You may want to maintain the DML directory separately in your repo. 
  * It is assumed that all other tables of master DB are already updated.
 
## Device provider partner registation
  * Update the following CSVs in PMS DML directory.  On sandbox the DMLs are located at `/home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/partner-management-services/db_scripts/mosip_pms/dml`.
    * `pms-partner.csv`
    * `pms-partner_h.csv`
    * `pms-policy_group.csv`
  * Run `update_pmsdb.sh`. Example: 
    ```
    $ ./update_pmsdb.sh /home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/partner-management-services/db_scripts/mosip_pms
    ```
  * CAUTION: The above will reset entire DB and load it fresh.  
  * Some example CSVs are located at `csv/pms`.

## Device registation
  * Update the following CSVs in Regdevice DML directory.  On sandbox the DMLs are located at `/home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/common/db_scripts/mosip_regdevice/dml`.
    * `regdevice-device_detail.csv`
    * `regdevice-secure_biometric_interface.csv`
    * `regdevice-registered_device_master.csv`
    * `regdevice-secure_biometric_interface_h.csv`
    * `regdevice-registered_device_master_h.csv`
  * Run `update_regdevicedb.sh`. Example: 
    ```
    $ ./update_regdevicedb.sh /home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp/commons/db_scripts/mosip_regdevice
    ```
  * CAUTION: The above will reset entire DB and load it fresh.  
  * Some example CSVs are located at `csv/regdevice`.

## IDA check
Disable IDA check in `registration-mz.properties`:
```
mosip.registration.onboarduser_ida_auth=N
```

## Launch Reg Client
1. Set Environment Variable `mosip.hostname` to `<sandbox domain name>`.
1. Login as a user (e.g. `110011`) with password (`mosip`) to login into the client. 


