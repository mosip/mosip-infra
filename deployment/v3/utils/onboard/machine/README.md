# Machine onboarding

Scripts here onboard machines for registrations.  The machines are typically laptops/desktops that would run the MOSIP registration client app.  These machines need to be onboarded on to the system with name, TPM public keys, registration center, zone etc. 

## Process
Define
1. Machine types
1. Machine specs
1. Machine details

## Machine info
Update the Excel sheets under `xls/`

## Attributes
* 5 digit machine ID is generated automatically and assigned to the machine. 
* Machine name should be unique for each machine and must match the name on the reg client machine.
* Obtain machine public key and sign public key using using [TPM utility](../../tpm/key_extractor).  Know more about TPM [here].(../../../docs/tpm.md)

## Prequisites
* Install `python3`  
* Install required modules
```sh
pip3 install -r requirements.txt
```
* Onboard an "admin" user and obtain secret for `mosip-regproc-client` as given [here](../user/README.md).

## Run the scripts
```sh
SERVER=https://api-internal.<your_doman>
python3 lib/add_.py $SERVER xlsx/machine.xlsx <admin user> <admin password> <mosip-regproc-client secret>
python3 lib/add_type.py 
```
WARNING: Default behaviour of the scripts is to **update** a record if it already exists. 
