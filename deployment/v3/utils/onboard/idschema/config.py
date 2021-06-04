import os

server = 'https://api-internal.sandbox.mosip.net'  # Ingress
ssl_verify = True

superadmin_user = 'puneet'
superadmin_pwd =  os.getenv('SUPERADMIN_PWD')
csv_idschema = 'csv/idschema.csv'

