import requests
import sys
sys.path.insert(0, '../')
from utils import *

class MosipSession:
    def __init__(self, server, user, pwd, appid='ida', ssl_verify=True):
        self.server = server
        self.user = user
        self.pwd = pwd
        self.ssl_verify = ssl_verify
        self.token = self.auth_get_token(appid, self.user, self.pwd) 

    def auth_get_token(self, appid, username, pwd):
        url = '%s/v1/authmanager/authenticate/useridPwd' % self.server
        ts = get_timestamp()
        j = {
            "id": "mosip.io.userId.pwd",
            "metadata" : {},
                "version":"1.0",
                "requesttime": ts,
                "request": {
                    "appId" : appid,
                    "userName": username,
                    "password": pwd
            }
        }
        r = requests.post(url, json = j)
        token = read_token(r)
        return token
      
    def upload_idschema(self, ui_spec, title, description):
        '''
        schema: as python type - dict, or list, but not is json string
      
        To avoid effective date < current date due to minor mismatch in server time, we add some offset in timestamp.
        '''
        url = '%s/v1/masterdata/idschema' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp(seconds_offset=1) # See note above 
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
               'schema': ui_spec,
               'schemaVersion' : '',  # Unused
               'title': title,
               'description': description,
               'effectiveFrom': ts
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r 

    def publish_idschema(self, schema_id):
        '''
        To avoid effective date < current date due to minor mismatch in server time, we add some offset in timestamp.
        '''
        url = '%s/v1/masterdata/idschema/publish' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp(seconds_offset=1) # See note above 
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
               'effectiveFrom': ts,
               'id': schema_id
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.put(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r 

