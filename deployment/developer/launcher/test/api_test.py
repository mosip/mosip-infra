import json
import requests
import os
import datetime as dt

def print_response(r):
    print(r.headers)
    print(r.links)
    print(r.encoding)
    print(r.status_code)
    print('Size = %s' % len(r.content))
    print('Response Data = %s' % r.content)
     
def get_timestamp():
    '''
    Current TS.
    Format: 2019-02-14T12:40:59.768Z  (local time)
    '''
    ts = dt.datetime.utcnow()
    ms = ts.strftime('%f')[0:2]
    s = ts.strftime('%Y-%m-%dT%H:%M:%S') + '.%sZ' % ms
    return s 
 
def prereg_send_otp():
    '''
    Add use email id below. 
    '''
    url ='http://localhost:9090/preregistration/v1/login/sendOtp'
    j = {
        "id": "mosip.pre-registration.login.sendotp",
        "version": "1.0",
        "requesttime": "2019-08-28T14:00:47.605Z",
        "request": {
            "userId": "xyz@gmail.com"
        }
    }

    r = requests.post(url, json=j)

    print_response(r)

def read_token(response):
    cookies = response.headers['Set-Cookie'].split(';')
    for cookie in cookies:
        key = cookie.split('=')[0]
        value = cookie.split('=')[1]
        if key == 'Authorization':
            return value

    return None

def auth_get_token(appid, username, password):
    url = 'http://localhost:8191/v1/authmanager/authenticate/useridPwd'
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

def get_public_key(appid, center_id, machine_id, token):
    url = 'http://localhost:8188/v1/keymanager/publickey/REGISTRATION'
    cookies = {'Authorization' : token}
    refid = center_id + '_' + machine_id
    r = requests.get(url, params = {'referenceId' : refid,
                                    'timeStamp' : get_timestamp()}, 
                     cookies = cookies)
    r = json.loads(r.content) # Get dict
    return r['response']['publicKey'] 

def test_reg_proc():
    '''
    1. First get authorization token (whos?) 
    2. Using keymanager API get public key of center_machine (rid)
    3. Create packet and encrypt using the above public key
    4. Sync Packet
    5. Upload packet
    '''
    token = auth_get_token('registrationprocessor', 'registration_admin',
                            'mosip')
    key = get_public_key('REGISTRATION', '10001', '10001', token)
    print(key)
    
def main():
    #prereg_send_otp()
    test_reg_proc()

if __name__=='__main__':
    main() 

