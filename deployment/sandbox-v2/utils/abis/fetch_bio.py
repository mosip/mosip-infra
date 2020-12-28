#!/bin/python3
from api import *
import config as conf
import requests
import sys

url = sys.argv[1]

session = MosipSession(conf.server, conf.abis_user, conf.abis_pwd, 'partner', ssl_verify=conf.ssl_verify, 
                       client_token=True)
cookies = {'Authorization' : session.token}
r = requests.get(url, cookies=cookies, verify=conf.ssl_verify)
print(r.content)

