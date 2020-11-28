import datetime as dt
import requests
import json
import base64
import os
import secrets
import sys
sys.path.insert(0, '../')
from utils import *

class MosipSession:
    def __init__(self, server, user, pwd, appid='ida'):
        self.server = server
        self.user = user
        self.pwd = pwd
        self.token = self.auth_get_token(appid, self.user, self.pwd) 
      
    def auth_get_token(self, appid, client_id, pwd):
        url = 'https://%s/v1/authmanager/authenticate/clientidsecretkey' % self.server
        ts = get_timestamp()
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'appId': appid,
                'clientId': client_id,
                'secretKey': pwd
            },
            'requesttime': ts,
            'version': '1.0'
        }

        r = requests.post(url, json = j)
        token = read_token(r)
        return token

    def get_ida_internal_cert(self):
        url = 'https://%s/idauthentication/v1/internal/getCertificate?applicationId=IDA&referenceId=CRED_SERVICE' % \
               self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        r = requests.get(url, cookies=cookies)
        r = response_to_json(r)
        return r

    def upload_other_domain_cert(self, cert):
        url = 'https://%s/v1/keymanager/uploadOtherDomainCertificate' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp() 
        j = {
            'id': 'string',
            'metadata': {},
            'request': {
                'applicationId': 'IDA',
                'certificateData': cert,
                'referenceId': 'PUBLIC_KEY'
            },
            'requesttime': ts,
            'version': '1.0'
        }
        r = requests.post(url, cookies=cookies, json = j)
        r = response_to_json(r)
        return r 
