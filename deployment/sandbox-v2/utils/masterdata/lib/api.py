import datetime as dt
import requests
import json
import base64
import os
import secrets
import sys
from utils import *

class MosipSession:
    def __init__(self, server, user, pwd, appid='admin', ssl_verify=True):
        self.server = server
        self.user = user
        self.pwd = pwd
        self.ssl_verify = ssl_verify
        self.token = self.auth_get_token(appid, self.user, self.pwd)

    def auth_get_token(self, appid, username, pwd):
        url = '%s/v1/authmanager/authenticate/useridPwd/' % self.server
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
        r = requests.post(url, json = j, verify=self.ssl_verify)
        token = read_token(r)
        return token

    def bulk_upload(self, category, file_name, operation, table_name):
        url = '%s/v1/admin/bulkupload' % self.server
        cookies = {'Authorization' : self.token}
        ts = get_timestamp()
        files = {'files': open(file_name,'rb')}
        j = {
            'id': 'bulkUpload.in.Bulk',
            'metadata': {},
            'category': category,
            'operation': operation,
            'tableName': table_name,
            'requesttime': ts,
            'version': '1.0',
        }
        r = requests.post(url, cookies=cookies, data=j, files=files, verify=self.ssl_verify)
        return r
