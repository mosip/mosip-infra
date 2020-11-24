import datetime as dt
import requests
import json
import hashlib
import os
import shutil

def read_token(response):
    cookies = response.headers['Set-Cookie'].split(';')
    for cookie in cookies:
        key = cookie.split('=')[0]
        value = cookie.split('=')[1]
        if key == 'Authorization':
            return value

    return None

def myprint(msg):
    print('==== %s' % msg)

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

def sha256_hash(data):
    '''
    data assumed as type bytes
    '''
    m = hashlib.sha256()
    m.update(data)
    h = m.hexdigest().upper()
    return h

def response_to_json(r):
    r = r.content.decode() # to str 
    r = json.loads(r)
    return r

def print_response(r):
    print('Status code =  %s' % r.status_code)
    print('Headers =  %s' % r.headers)
    print('Links =  %s' % r.links)
    print('Encoding = %s' % r.encoding)
    print('Response Data = %s' % r.content)
    print('Size = %s' % len(r.content))
 
def zip_packet(regid, base_path, out_dir):
    '''
    Args:
        regid: Registration id - this will be the name of the packet
        base_path:  Zip will cd into this dir and archive from here
        out_dir: Dir in which zip file will be written
    Returns:
        path of zipped packet
    '''
    out_path = os.path.join(out_dir, regid)
    shutil.make_archive(out_path, 'zip', base_path)
    return out_path + '.zip'
