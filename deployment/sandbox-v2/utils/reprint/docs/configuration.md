# Configuration (config.py)

```text
# Mosip host
rps_server = 'https://qa3.mosip.net'

# credential type, it can be euin/reprint/qrcode (its configured in regproc)
rps_credential_type='euin'

# Id of the partner that will consume the pdf
rps_partner_id='mpartner-default-print'

# Enforce ssl verification
rps_ssl_verify='y'

# Debug flag, if its 'y', then the script will generate additional logs
rps_debug='y'

# Credentials for generating authentication token for accessing APIs
rps_app_id="resident"
rps_client_id = "mpartner-default-print"
rps_secret_key = ""

# Credentials for database connection
rps_db_host = 'qa3.mosip.net'
rps_db_port = '30090'
rps_db_user = ''
rps_db_pass = ''
```