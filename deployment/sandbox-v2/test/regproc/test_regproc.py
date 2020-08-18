#!/bin/python3

import base64
import os
import config as conf
import datetime as dt
import shutil
import glob
import subprocess
from common import *
import  jinja2 as j2

def update_conf(conf, mosip):
    '''
    Update the dynamic fields of conf dictonary
    '''
    rid = mosip.get_rid(conf.pkt_conf['center_id'], conf.pkt_conf['machine_id'])
    conf.pkt_conf['rid'] = rid 

    ts = dt.datetime.now().strftime('%Y-%m-%dT%H:%M:%S.000Z')
    conf.pkt_conf['creation_date'] = ts

def template_to_packet(conf, suffix):
    out_dir = os.path.join(conf.unenc_dir, suffix)
    
    os.makedirs(out_dir)  # Assumed parent directory is cleaned up before calling this func

    # First copy all files from templates to out_dir as is, then replace the template files
    in_dir = os.path.join(conf.template_dir, suffix)
    files = glob.glob(os.path.join(in_dir, '*'))
    for f in files:
        shutil.copy(f, os.path.join(out_dir))

    # Convert all templates and overwrite files in out_dir
    loader = j2.FileSystemLoader(in_dir)
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
   paths = []
   for sub_pkt in conf.sub_pkts:
       base_path = os.path.join(conf.unenc_dir, sub_pkt) 
       out_zip = os.path.join(conf.unenc_dir, conf.pkt_conf['rid'] + '_' + sub_pkt)
       r = shutil.make_archive(out_zip, 'zip', base_path)
       paths.append(out_zip + '.zip')
 
   return paths 

def cleanup(conf):
    if os.path.exists(conf.unenc_dir):
        shutil.rmtree(conf.unenc_dir)

    if os.path.exists(conf.enc_dir):
        shutil.rmtree(conf.enc_dir)

def template_to_packets(conf):
    for suffix in conf.sub_pkts:
        template_to_packet(conf, suffix)
  
def update_hashes(conf):
    for suffix in conf.sub_pkts:
       meta_path = os.path.join(os.path.join(conf.unenc_dir, suffix), 'packet_meta_info.json')
       subprocess.run(['./gen_hash.py %s' % meta_path], shell=True)

def sync_packet(conf, mosip, final_zip, refid): 
    data = open(final_zip, 'rb').read()  # data is in 'bytes'
    phash = sha256_hash(data)
    psize = len(data)
    rid = conf.pkt_conf['rid'] 

    r = mosip.sync_packet(rid, phash, psize, refid)
    return r

def create_final_zip(conf):
    # Zip all the encrypted packets into single zip (which is not encrypted)
    os.system('rm -f %s/*.zip' % conf.pkt_dir) # Remove any existing zip files
    out_zip = os.path.join(conf.pkt_dir, conf.pkt_conf['rid']) 
    final_zip = shutil.make_archive(out_zip, 'zip', conf.enc_dir) 
    return final_zip

def main():

    cleanup(conf)  # Cleanup an existing dirs

    refid = conf.pkt_conf['center_id'] + '_' + conf.pkt_conf['machine_id']
    mosip = MosipSession(conf.server, conf.user, conf.password)
      
    update_conf(conf, mosip)

    template_to_packets(conf)

    update_hashes(conf)

    zipped_pkts = zip_packets(conf)

    os.makedirs(conf.enc_dir)
    for zipped_pkt in zipped_pkts:
        mosip.encrypt_packet(zipped_pkt, conf.enc_dir, os.path.basename(zipped_pkt), refid)

    final_zip = create_final_zip(conf)

    print('\n=== Syncing packet === \n')
    r = sync_packet(conf, mosip, final_zip, refid) 
    print_response(r) 

    print('\n=== Uploading packet === \n')
    r = mosip.upload_packet(final_zip)
    print_response(r)


if __name__=="__main__":
    main()
