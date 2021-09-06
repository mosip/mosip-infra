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
    def __init__(self, server, user, pwd, client, client_secret, appid='regproc', ssl_verify=True, client_token=False):
        self.server = server
        self.user = user
        self.pwd = pwd
        self.ssl_verify = ssl_verify
        if client_token:
            self.token = self.auth_get_client_token(appid, self.user, self.pwd) 
        else:
            self.token = self.auth_get_token(appid, client, client_secret, self.user, self.pwd) 
      
    def auth_get_token(self, appid, client, client_secret, username, pwd):
        url = '%s/v1/authmanager/authenticate/internal/useridPwd' % self.server
        ts = get_timestamp()
        j = {
            "id": "mosip.io.userId.pwd",
            "metadata" : {},
                "version":"1.0",
                "requesttime": ts,
                "request": {
                    "appId" : appid,
                    "userName": username,
                    "password": pwd,
                    'clientId': client,
                    'clientSecret': client_secret
            }
        }
        r = requests.post(url, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        token = r['response']['token'] 
        return token

    def auth_get_client_token(self, appid, client_id, pwd):
        url = '%s/v1/authmanager/authenticate/clientidsecretkey' % self.server
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

        r = requests.post(url, json = j, verify=self.ssl_verify)
        token = read_token(r)
        return token

    def map_user_to_reg_center(self, username, regcenter):
        url = '%s/v1/masterdata/users/%s/eng/%s' % (self.server, username, regcenter)
        cookies = {'Authorization' : self.token}
        ## TODO: POST is buggy, so we use PUT for now
        r = requests.put(url, cookies=cookies, verify=self.ssl_verify)
        r = response_to_json(r)
        return r

    def map_user_to_zone(self, username, zone, update=False):
        url = '%s/v1/masterdata/zoneuser/' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
            "id": "string",
            "metadata": {},
            "request": {
              "isActive": True,
              "langCode": "eng", # Doesn't matter
              "userId": username,
              "zoneCode": zone # Zone code
            },
            "requesttime": ts,
            "version": "1.0"
        }
        if update:
            r = requests.put(url, cookies=cookies, json = j, verify=self.ssl_verify)
        else:
            r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)

        r = response_to_json(r)
        return r
