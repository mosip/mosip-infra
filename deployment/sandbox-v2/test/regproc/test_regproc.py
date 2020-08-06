#!/bin/python3

import base64
import os
import config as conf
import datetime as dt
import shutil
from common import *
import  jinja2 as j2

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

def zip_packets(conf):
   '''
   Returns paths of output zip files
   '''
   os.system('rm %s/*.zip' % conf.unenc_dir) # Remove any existing zip files

   paths = []
   for sub_pkt in conf.sub_pkts:
       base_path = os.path.join(conf.unenc_dir, sub_pkt) 
       out_zip = os.path.join(conf.unenc_dir, conf.pkt_conf['rid'] + '_' + sub_pkt)
       r = shutil.make_archive(out_zip, 'zip', base_path)
       paths.append(out_zip + '.zip')
 
   return paths 

def make_dirs(conf):
    for suffix in conf.sub_pkts:
        os.makedirs(os.path.join(conf.unenc_dir, suffix), exist_ok=True)

def template_to_packets(conf):
    for suffix in conf.sub_pkts:
        template_to_packet(conf, os.path.join(conf.template_path,  suffix), 
                           os.path.join(conf.unenc_dir, suffix))
  
def sync_packet(conf, mosip, final_zip, refid): 
    data = open(final_zip, 'rb').read()  # data is in 'bytes'
    phash = sha256_hash(data)
    psize = len(data)
    rid = conf.pkt_conf['rid'] 

    r = mosip.sync_packet(rid, phash, psize, refid)
    return r

def main():

    make_dirs(conf)

    refid = conf.pkt_conf['center_id'] + '_' + conf.pkt_conf['machine_id']
    mosip = MosipSession(conf.server, conf.user, conf.password)
      
    update_conf(conf, mosip)

    template_to_packets(conf)

    zipped_pkts = zip_packets(conf)

    os.system('rm %s/*.zip' % conf.enc_dir) # Remove any existing zip files
    for zipped_pkt in zipped_pkts:
        mosip.encrypt_packet(zipped_pkt, conf.enc_dir, os.path.basename(zipped_pkt), refid)

    # Zip all the encrypted packets into single zip (which is not encrypted)
    os.system('rm %s/*.zip' % conf.pkt_dir) # Remove any existing zip files
    out_zip = os.path.join(conf.pkt_dir, conf.pkt_conf['rid']) 
    final_zip = shutil.make_archive(out_zip, 'zip', conf.enc_dir) 

    r = sync_packet(conf, mosip, final_zip, refid) 
    print_response(r) 

    exit(0) 

    print('Uploading packet')
    r = upload_packet(packet_path, token, SERVER)
    print_response(r)


if __name__=="__main__":
    main()
