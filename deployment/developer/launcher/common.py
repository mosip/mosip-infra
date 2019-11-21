import subprocess
import logging
import requests
import os
import csv
from config import *
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

def command(cmd):
    r = subprocess.run(cmd, shell=True)
    if r.returncode != 0: 
        logger.error(r)
        
def get_jar_name(service, version):
    return service + '-' + version + '.jar'

def start_service(module, service, version, options, suffix):
    jar_dir = '%s/.m2/repository/io/mosip/%s/%s/%s' % (os.environ['HOME'], 
               module, service, version)
    jar_name = get_jar_name(service, version)
    run_jar(jar_dir, jar_name, LOGS_DIR, CONFIG_SERVER_PORT,  JAVA_HEAP_SIZE, 
            options, suffix)

def run_jar(jar_dir, jar_name, logs_dir, config_port, 
            max_heap_size=JAVA_HEAP_SIZE, add_options='', 
            log_suffix=''):
    '''
    Args:
        add_options:  Any additional options in the for '-D<option>'
        log_suffix: Suffix to be added to log file name. Useful when mutliple
            instances of same service are run 
    '''
    logger.info('Running jar %s' % jar_name)
    cwd = os.getcwd() 
    os.chdir(jar_dir)
    options = [
        '-Dspring.cloud.config.uri=http://localhost:%d' % config_port, 
        '-Dspring.cloud.config.label=master',
        '-Dspring.profiles.active=dev',
        '-Xmx%s' % max_heap_size,
        add_options 
    ]
    cmd = 'java %s -jar %s >>%s/%s.server%s.log 2>&1 &' % (' '.join(options), 
                                                    jar_name, logs_dir, 
                                                    jar_name,   log_suffix)
    logger.info('Command: %s' % cmd)
    command(cmd)
    logger.info('%s run in background' % jar_name)
    os.chdir(cwd)

def kill_process(search_str):
    '''
    Search a process whos command contains search_str and kill it.
    The command line arguments of a command are concatenated into a string 
    for easy searching. The char used for concatenation is unlikely char like
    #.
    '''
    import psutil # Moved here in case module not found during launcher load 
    for p in psutil.process_iter():
        pinfo = p.as_dict(attrs=['pid', 'cmdline'])
        if search_str in '#'.join(pinfo['cmdline']):
            p.kill()

def read_token(response):
    cookies = response.headers['Set-Cookie'].split(';')
    for cookie in cookies:
        key = cookie.split('=')[0]
        value = cookie.split('=')[1]
        if key == 'Authorization':
            return value

    return None

def auth_get_token(appid, username, password):

    url = 'http://localhost/v1/authmanager/authenticate/useridPwd'
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
    #['1234','F8-B4-6A-B2-0E-59','DESKTOP-A96IHMO','Marie Catherine L. Garilao', 'REG203', 'h@ppyBox24', '10001', 'REGISRTATION_OFFICER]

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
        user_infos.append(u)
    return user_infos
