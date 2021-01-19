# Machine onboarding

Scripts here onboard machines for registrations.  The machines are typically laptops/desktops that would run the MOSIP registration client app.  These machines need to be onboarded on to the system with name, TPM public keys, registration center, zone etc. 

## Process
Define
1. Machine types
1. Machine specs
1. Machine details

The specification is in JSON format.  See `data/` folder for examples

## Attributes
* 5 digit machine ID is generated automatically and assigned to the machine. 
* Machine name should be unique for each machine and must match the name on the reg client machine.

## Keys
Folder `keys` contains RSA encryption and sign public keys of a machine obtained using [TPM utility](../../tpm/key_extractor).  Know more about TPM [here].(../../../docs/tpm.md)

## Languages
Master DB records any text info associated with machines as sepearate rows for each language defined in mosip config.  You need to specify text in all languages that have been defined.  See examples in `data/`.

## Config
1. Set the `server` url in `config.py`
1. If the url has HTTPS and server SSL certificate is self-signed then set `ssl_verify=False`.
1. Set postgres parameters.

## Run
```
./onboard.py --help
```
You may specify individual JSON file or an entire folder as input.  In folder is specified, all JSONs are picked up recursively.

WARNING: Default behaviour of the scripts is to **update** a record if it already exists.  So be mindful of any changes in the JSONs.  You will not be prompted or warned for any updates to existing records.
