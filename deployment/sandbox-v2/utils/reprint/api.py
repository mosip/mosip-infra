import json
import sys
import config as conf
import requests

from utils import getTimestamp, readToken, myPrint, dictToJson

sys.path.insert(0, '../')


class MosipSession:
    def __init__(self, server, user, pwd, appid='resident', ssl_verify=True):
        self.server = server
        self.user = user
        self.pwd = pwd
        self.ssl_verify = ssl_verify
        self.token = self.authGetToken(appid, self.user, self.pwd)

    def authGetToken(self, appid, username, pwd):
        myPrint("authenticate api called")
        url = '%s/v1/authmanager/authenticate/clientidsecretkey' % self.server
        ts = getTimestamp()
        j = {
            "id": "mosip.io.clientId.pwd",
            "metadata": {},
            "version": "1.0",
            "requesttime": ts,
            "request": {
                "appId": appid,
                "clientId": username,
                "secretKey": pwd
            }
        }
        if conf.debug:
            myPrint("Request: "+dictToJson(j))
        r = requests.post(url, json=j, verify=self.ssl_verify)
        resp = self.parseResponse(r)
        if conf.debug:
            myPrint("Response: "+dictToJson(resp))
        token = readToken(r)
        return token

    def getUin(self, vid):
        myPrint("Get uin from vid api called")
        url = '%s/idrepository/v1/identity/idvid/%s' % (self.server, vid)
        cookies = {'Authorization': self.token}
        r = requests.get(url, cookies=cookies, verify=self.ssl_verify)
        resp = self.parseResponse(r)
        if conf.debug:
            myPrint("Response: "+dictToJson(resp))
        return resp

    def credentialRequest(self, request):
        myPrint("addApplication api called")
        url = '%s/v1/credentialrequest/requestgenerator' % self.server
        cookies = {'Authorization': self.token}
        ts = getTimestamp()
        j = {
            "id": "mosip.credentialrequest",
            "request": request,
            "requesttime": ts,
            "version": "1.0"
        }
        if conf.debug:
            myPrint("Request: " + dictToJson(j))
        r = requests.post(url, cookies=cookies, json=j, verify=self.ssl_verify)
        resp = self.parseResponse(r)
        if conf.debug:
            myPrint("Response: "+dictToJson(resp))
        return resp

    @staticmethod
    def parseResponse(r):
        if r.status_code != 200:
            raise RuntimeError("Request failed with status: "+str(r.status_code)+", "+str(r.content))
        if r.content is not None:
            res = json.loads(r.content)
            if res['response'] is None:
                raise RuntimeError(res['errors'])
            else:
                return res['response']
