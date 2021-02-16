import os

server = os.getenv("rps_server")
credential_type = os.getenv("rps_credential_type")
partner_id = os.getenv("rps_partner_id")

ssl_verify = True if os.getenv("rps_ssl_verify") == 'y' else False
debug = True if os.getenv("rps_debug") == 'y' else False

app_id = os.getenv("rps_app_id")
client_id = os.getenv("rps_client_id")
secret_key = os.getenv("rps_secret_key")

# Database
db_host = os.getenv("rps_db_host")
db_port = os.getenv("rps_db_port")
db_user = os.getenv("rps_db_user")
db_pass = os.getenv("rps_db_pass")

# JSON print related
json_sort_keys = True
json_indent = 4
