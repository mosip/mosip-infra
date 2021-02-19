# Configuration (.env)

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

# Credentials for generating authentication token for credential request services
rps_ida_app_id="ida"
rps_ida_client_id = ""
rps_ida_secret_key = ""

# Credentials for generating authentication token for getting additional info using VID
rps_regproc_app_id="regproc"
rps_regproc_client_id = ""
rps_regproc_secret_key = ""

rps_idrepo_modulo="1000"

# Script will check whether the same request for credential issue has been sent or not within {rps_time_filter_in_seconds} seconds
# If script finds same request in db where time < now - {rps_time_filter_in_seconds} seconds, then script will not fire credential issuance
rps_time_filter_in_seconds="1000"

# Credentials for database connection
rps_db_host = 'qa3.mosip.net'
rps_db_port = '30090'
rps_db_user = ''
rps_db_pass = ''
```