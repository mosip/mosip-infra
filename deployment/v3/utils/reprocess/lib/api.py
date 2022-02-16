import datetime as dt
import requests
import json
import base64
import os
import secrets
import sys
sys.path.insert(0, '../onboard')
from utils import *

class MosipSession:
    def __init__(self, server, user, pwd, client, client_secret, appid='admin', ssl_verify=True, client_token=False):
        self.server = server
        self.ssl_verify = ssl_verify
        if client_token:
            self.token = self.auth_get_client_token(appid, client, client_secret) 
        else:
            self.token = self.auth_get_token(appid, client, client_secret, user, pwd) 
      
    def auth_get_token(self, appid, client, client_secret, username, pwd):
        url = '%s/v1/authmanager/authenticate/internal/useridPwd' % self.server
        ts = get_timestamp()
        j = {
            'id': 'mosip.io.userId.pwd',
            'metadata' : {},
            'version':'1.0',
            'requesttime': ts,
            'request': {
                'appId' : appid,
                'userName': username,
                'password': pwd,
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

    def notify_securezone(self, rid, workflow_id):
        url = '%s/registrationprocessor/v1/securezone/notification' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        j = {
           'reg_type': 'NEW',
           'rid': rid, 
           'isValid': True,
           'internalError': False,
           'messageBusAddress': None,
           'retryCount': None,
           'tags': None, 
           'lastHopTimestamp': None,
           'source': None, 
           'iteration': 1,
           'workflowInstanceId': workflow_id
        }
        r = requests.post(url, cookies=cookies, json = j, verify=self.ssl_verify)
        r = response_to_json(r)
        return r
