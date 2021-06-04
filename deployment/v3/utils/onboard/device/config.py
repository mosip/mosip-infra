import os

server = 'https://minibox.mosip.net' 
ssl_verify=True

db_user = os.getenv('DB_USER')
db_pwd = os.getenv('DB_PWD') 
db_host = os.getenv('DB_HOST') 
db_port = os.getenv('DB_PORT')

device_provider_user = 'deviceprovider1' # with DEVICE_PROVIDER role
device_provider_pwd = 'mosip'

partner_manager_user = 'partnermanager1' # with PARTNERMANAGER role
partner_manager_pwd = 'mosip'

superadmin_user = 'superadmin'
superadmin_pwd = os.getenv('SUPERADMIN_PWD')

