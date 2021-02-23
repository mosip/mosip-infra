#server = 'https://minibox.mosip.net' 
server = ''
ssl_verify=True

client_id = 'mosip-regproc-client'
client_pwd = 'abc123'

db_user = 'postgres'
db_pwd = ''
db_host = 'mzworker0.sb'  
db_port = '30090'
query="select id from registration where status_code = 'PROCESSING' and latest_trn_type_code = 'PACKET_REPROCESS' and latest_trn_status_code = 'SUCCESS'"
delay = 5  # seconds
