import os

#server = 'https://minibox.mosip.net' 
server = ''
ssl_verify=True

client_id = 'mosip-regproc-client'
client_pwd = os.getenv('REGPROC_CLIENT_PWD')

db_user = os.getenv('DB_USER')
db_pwd = os.getenv('DB_PWD') 
db_host = os.getenv('DB_HOST') 
db_port = os.getenv('DB_PORT')

query="select id from registration where status_code = 'PROCESSING' and latest_trn_type_code = 'PACKET_REPROCESS' and latest_trn_status_code = 'SUCCESS'"
delay = 5  # seconds
