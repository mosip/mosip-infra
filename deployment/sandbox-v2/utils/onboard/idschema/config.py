import os

server = 'http://mzingress.sb:30080'  # Ingress
#server = 'https://minibox.mosip.net'
ssl_verify = True

superadmin_user = 'superadmin'
superadmin_pwd =  os.gentenv('SUPERADMIN_PWD')
csv_idschema = 'csv/idschema.csv'

