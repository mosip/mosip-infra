import subprocess
import logging
import requests
import os
import csv
import datetime as dt
import hashlib

logger = logging.getLogger(__name__)

class UserInfo:
    def __init__(self):
        self.uid= None
        self.user_name = None
        self.user_password = None
        self.user_email = None
        self.user_mobile = None
        self.machine_mac = None
        self.machine_name = None
        self.center_id = None
        self.role = None  # Roles as in LDAP
        self.zone_code = None
        self.lang_code = None

def command(cmd):
    r = subprocess.run(cmd, shell=True)
    if r.returncode != 0: 
        logger.error(r)
        
def read_token(response):
    cookies = response.headers['Set-Cookie'].split(';')
    for cookie in cookies:
        key = cookie.split('=')[0]
        value = cookie.split('=')[1]
        if key == 'Authorization':
            return value

    return None

def auth_get_token(appid, username, password, root):
    url = root + '/v1/authmanager/authenticate/useridPwd'
    ts = get_timestamp()
    j = {
        "id": "mosip.io.userId.pwd",
        "metadata" : {},
            "version":"1.0",
            "requesttime": ts, 
            "request": {
                "appId" : appid, 
                "userName": username,
                "password": password
        }
    }
    r = requests.post(url, json = j)
    token = read_token(r) 
    return token 

def get_timestamp(days_offset=None):
    '''
    Current TS.
    Format: 2019-02-14T12:40:59.768Z  (UTC)
    '''
    delta = dt.timedelta(days=0)
    if days_offset is not None:
        delta = dt.timedelta(days=days_offset)
         
    ts = dt.datetime.utcnow() + delta
    ms = ts.strftime('%f')[0:2]
    s = ts.strftime('%Y-%m-%dT%H:%M:%S') + '.%sZ' % ms
    return s 

def generate_machine_id_from_mac(mac, nchars):
    '''
    Args:
        mac: mac address as str (format does not matter)
        nchars: number of chars in id 
    '''

    m = hashlib.md5()
    m.update(mac.encode())
    machine_id = m.hexdigest()[0 : nchars]

    return machine_id
    
def parse_umc_csv(csv_file):
    '''
    User-machine-center mapping is specified in a csv as
    [mac,machine_name,user_name,uid,password,user_email,user_mobile,
     center_id,ldap_role']
    '''
    f = open(csv_file, 'rt')
    reader = csv.reader(f)    
    next(reader, None)  # Skip header row

    user_infos = []
    for row in reader:
        u = UserInfo()
        u.machine_mac = row[0]
        u.machine_name = row[1]
        u.user_name = row[2]
        u.uid = row[3] 
        u.user_password = row[4]
        u.user_email = row[5]
        u.user_mobile = row[6]
        u.center_id = row[7] 
        u.role = row[8] # Currently only one role is assumed. TODO.
        u.zone_code = 'PHIL' # Default, so hardcoded 
        u.lang_code = 'eng' # Default, so hardcoded
        user_infos.append(u)
    return user_infos
