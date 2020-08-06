#!/bin/python3

import base64
import os
import config as conf
import datetime as dt
from common import *
import  jinja2 as j2

def zip_packets(prefix, conf):
    # Create dirs
    os.makedirs(unenc_dir, exist_ok=True)
    os.makedirs(enc_dir, exist_ok=True)

  
def update_conf(conf, mosip):
    '''
    Update the dynamic fields of conf dictonary
    '''
    rid = mosip.get_rid(conf.pkt_conf['center_id'], conf.pkt_conf['machine_id'])
    conf.pkt_conf['rid'] = rid 

    ts = dt.datetime.now().strftime('%Y-%m-%dT%H:%M:%S.000Z')
    conf.pkt_conf['create_time'] = ts
    conf.pkt_conf['date_time'] = ts

def template_to_packet(conf, template_path, out_dir):
    loader = j2.FileSystemLoader(os.path.join(conf.template_path, 'id'))
    env = j2.Environment(loader = loader)
    template_files = loader.list_templates()
    template_files = [f for f in template_files if f.split('.')[-1] == 'json']  # Pick only json files 
    for template_file in template_files:
        template = env.get_template(template_file) 
        out = template.render(conf.pkt_conf) # Pass the conf dictionary
        fp = open (os.path.join(out_dir, template_file), 'wt')
        fp.write(out)
        fp.close()

def make_dirs(conf):

    for suffix in conf.sub_pkts:
        os.makedirs(os.path.join(conf.unenc_dir, suffix), exist_ok=True)
        os.makedirs(os.path.join(conf.enc_dir, suffix), exist_ok=True)
   
def main():

    make_dirs(conf)

    refid = conf.pkt_conf['center_id'] + '_' + conf.pkt_conf['machine_id']
    mosip = MosipSession(conf.server, conf.user, conf.password)
      
    update_conf(conf, mosip)

    # Convert templates
    for suffix in conf.sub_pkts:
        template_to_packet(conf, os.path.join(conf.template_path,  suffix), 
                           os.path.join(conf.unenc_dir, suffix))
    exit(0) 

    '''
    encrypt_packet(, ENCRYPTED_DIR, PACKET1, refid, token, SERVER)
    encrypt_packet(UNENCRYPTED_PACKET2, ENCRYPTED_DIR, PACKET2, refid, token, SERVER)
    encrypt_packet(UNENCRYPTED_PACKET3, ENCRYPTED_DIR, PACKET3, refid, token, SERVER)
    zip_packet(RID, ENCRYPTED_DIR,  BASE_DIR)
    
    data = open(os.path.join(BASE_DIR, PACKET), 'rb').read()  # data is in 'bytes'
    phash = sha256_hash(data)
    psize = len(data)
    
    regid = PACKET.split('.')[0]
    
    sync_packet(regid, phash, psize, refid, token, SERVER) 
    
    packet_path = os.path.join(BASE_DIR, PACKET)
    
    print('Uploading packet')
    r = upload_packet(packet_path, token, SERVER)
    print_response(r)
    '''


if __name__=="__main__":
    main()
