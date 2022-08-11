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

query="select reg_id,process,workflow_instance_id from registration where latest_trn_status_code in ('SUCCESS', 'REPROCESS', 'IN_PROGRESS') and reg_process_retry_count<=500 and latest_trn_dtimes < (SELECT NOW() - INTERVAL '1 DAY') and status_code NOT IN ('PROCESSED', 'FAILED', 'REJECTED') LIMIT 1000"
delay = 1  # seconds
