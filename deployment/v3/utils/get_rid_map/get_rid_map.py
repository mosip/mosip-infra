# Script to get UIN corresponding to a RID.
# Usage: python get_rid_map.py <rid file> <out csv>
import api
import os
import traceback
import random
import time
import json
import csv
from collections import OrderedDict

# Export the following env variables:
# SERVER: https://api-internal.v3box1.mosip.net
# CLIENT: mosip-resident-client
# SECRET: xyz 

def get_uin_from_response(r):
    return r['response']['identity']['UIN']

def print_usage():
    print('Usage: python get_rid_map.py <rid file> <out file>')
    print('Set the following shell env variables:') 
    print('export SERVER=https://<your server>')
    print('export CLIENT=mosip-regproc-client')
   print('export SECRET=<client secret>')

def main(argv):
   if len(argv) != 3:
       print_usage()
       return 0

   server=os.environ['SERVER']
   secret = os.environ['SECRET']
   client = os.environ['CLIENT']

   lines = open(argv[1], 'rt').readlines()
   rids = [line.strip() for line in lines]
   ofp = open(argv[2], 'wt')
   ofp.write('rid,uin\n') 

   try:
       token = api.auth_get_client_token(server, 'regproc', client, secret)
       for rid in rids:
           print(f'Processing rid {rid}')
           r = api.get_demographic_data(server, token, rid)
           uin = get_uin_from_response(r)
           ofp.write(f'{rid},{uin}\n')
   except:
        formatted_lines = traceback.format_exc()
        ofp.close()
        print(formatted_lines)
   ofp.close()

   return 0

if __name__ == '__main__':
    import sys
    sys.exit(main(sys.argv))

