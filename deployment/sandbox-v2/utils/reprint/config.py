import os

server = os.getenv("rps_server")
credential_type = os.getenv("rps_credential_type")
partner_id = os.getenv("rps_partner_id")

ssl_verify = True if os.getenv("rps_ssl_verify") == 'y' else False
debug = True if os.getenv("rps_debug") == 'y' else False

ida_app_id = os.getenv("rps_ida_app_id")
ida_client_id = os.getenv("rps_ida_client_id")
ida_secret_key = os.getenv("rps_ida_secret_key")

regproc_app_id = os.getenv("rps_regproc_app_id")
regproc_client_id = os.getenv("rps_regproc_client_id")
regproc_secret_key = os.getenv("rps_regproc_secret_key")

idrepo_modulo = int(os.getenv("rps_idrepo_modulo"))
time_filter_in_seconds = int(os.getenv("rps_time_filter_in_seconds"))

# Database
db_host = os.getenv("rps_db_host")
db_port = os.getenv("rps_db_port")
db_user = os.getenv("rps_db_user")
db_pass = os.getenv("rps_db_pass")

# JSON print related
json_sort_keys = True
json_indent = 4
