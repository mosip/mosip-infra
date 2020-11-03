# Configure Pre-Reg for ID Schema

The sandbox comes with its default ID Schema (in Master DB, `identity_schema` table) and Pre-Reg UI Schema [pre-registration-demographic.json](https://github.com/mosip/mosip-config/blob/1.1.2/sandbox/pre-registration-demographic.json)

In order to use different schemas, do the following:

1. Make sure new ID Schema is updated in Master DB, `identity_schema` table.
1. Replace `mosip-config/sandbox/pre-registration-demographic.json` with new Pre-Reg UI Schema.
1. Map values in `pre-registration-identity-mapping.json` to `pre-registration-demographic.json` as below.  
    ```
    {
        "identity": {
            "name": {
                "value":< id of name field in your demograhic json >
                "isMandatory" : true
            },
            "proofOfAddress": {
                "value" : < id of proof of address field in your demographic json>
            },
            "postalCode": {
                 "value" : <  id of postal code field in your demographic json>
            }
        }
    } 
    ```

1. Update the following properties in `pre-registration-mz.properties`:
    ```
    preregistartion.identity.name=< identity.name.value (above)>
    preregistration.notification.nameFormat=< identity.name.value>
    ```
1. Restart the Pre-Reg Application service.
