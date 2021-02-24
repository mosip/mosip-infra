import os

server = 'https://minibox.mosip.net'
ssl_verify = True

db_user = os.getenv('DB_USER')
db_pwd = os.getenv('DB_PWD') 
db_host = os.getenv('DB_HOST') 
db_port = os.getenv('DB_PORT')

keycloak_admin = 'admin'
keycloak_pwd = os.getenv('KEYCLOAK_PWD') 

