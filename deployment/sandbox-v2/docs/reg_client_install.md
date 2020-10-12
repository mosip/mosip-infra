# Registration Client Install 
This document provides steps to install Registration Client (RegC) to work with this sandbox.  The RegC runs on Windows. 
It is assumed that sandbox is successfully installed.

## Download RegC
Download RegC using the following url:
```
https://<sandbox domain name>/registration-client/1.1.2-SNAPSHOT/reg-client.zip
```
## Configure Master DB
Update the following in `mosip_master` database:
```
update master.machine_master set name='<MACHINE_NAME>' where id=10011;
update master.machine_master_h set name='<MACHINE_NAME>' where id=10011;
```
where `MACHINE_NAME` is your Windows machine name.  You may get the same from control panel -> system info. 

## RegC keys

1. Download the default RegC keys from the following url:
    ```
    https://<sandbox domain name>/regclientkeys.zip
    ```
1. Create the following folder on your Windows machines home directory:
    ```
    c:\Users\<user name>\.mosipkeys\ 
    ```
1. Unzip the above file and copy the contents of `regclientkeys/mosipkeys/*` into above folder
