#!/bin/python3

import base64
import os
import sys
import config as conf
import datetime as dt
import shutil
import glob
import subprocess
import importlib
from api import *
sys.path.insert(0, '../')
from utils import *
import  jinja2 as j2

TEMPLATE_DIR = conf.pkt_dir + '/template/REGISTRATION_CLIENT/NEW'
UNENC_DIR = conf.pkt_dir + '/unencrypted/REGISTRATION_CLIENT/NEW'
ENC_DIR = conf.pkt_dir + '/encrypted/REGISTRATION_CLIENT/NEW'
ZIP_IN_DIR = conf.pkt_dir + '/encrypted/'   # Dir from where zip needs to be created

class App:
    def __init__(self, conf):
        self.conf = conf
        self.sub_pkts = ['id', 'evidence', 'optional']  
        sys.path.insert(0, self.conf.pkt_dir)
        m = importlib.import_module('pktconf') # Expected to be in the packet dir
        self.pktconf = m.pkt_conf
    
    def update_conf(self, mosip):
        '''
        Update the dynamic fields of conf dictonary
        '''
        rid = mosip.get_rid(self.pktconf['center_id'], self.pktconf['machine_id'])
        self.pktconf['rid'] = rid 
    
        # Adding an extra second to ensure that server key creation time is before the packet time
        ts = (dt.datetime.utcnow() + dt.timedelta(seconds=1)).strftime('%Y-%m-%dT%H:%M:%S.000Z')
        self.pktconf['creation_date'] = ts
    
    def template_to_packet(self, suffix):
        out_dir = os.path.join(UNENC_DIR, suffix)
        
        os.makedirs(out_dir)  # Assumed parent directory is cleaned up before calling this func
    
        # First copy all files from templates to out_dir as is, then replace the template files
        in_dir = os.path.join(TEMPLATE_DIR, suffix)
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
            out = template.render(self.pktconf) # Pass the conf dictionary
            fp = open (os.path.join(out_dir, template_file), 'wb')
            fp.write(out.encode())  # For some reason read and write in text mode was throwing exception
            fp.close()
    
    def zip_packets(self):
       '''
       Returns paths of output zip files
       '''
       paths = []
       for sub_pkt in self.sub_pkts:
           base_path = os.path.join(UNENC_DIR, sub_pkt) 
           out_zip = os.path.join(UNENC_DIR, self.pktconf['rid'] + '_' + sub_pkt)
           r = shutil.make_archive(out_zip, 'zip', base_path)
           paths.append(out_zip + '.zip')
     
       return paths 
    
    def cleanup(self):
        if os.path.exists(UNENC_DIR):
            shutil.rmtree(UNENC_DIR)
    
        if os.path.exists(ENC_DIR):
            shutil.rmtree(ENC_DIR)
    
    def template_to_packets(self):
        for suffix in self.sub_pkts:
            self.template_to_packet(suffix)
      
    def update_hashes(self):
        for suffix in self.sub_pkts:
           meta_path = os.path.join(os.path.join(UNENC_DIR, suffix), 'packet_meta_info.json')
           subprocess.run(['./gen_hash.py %s' % meta_path], shell=True)
    
    def sync_packet(self, mosip, final_zip, refid): 
        data = open(final_zip, 'rb').read()  # data is in 'bytes'
        phash = sha256_hash(data)
        psize = len(data)
        rid = self.pktconf['rid'] 
    
        r = mosip.sync_packet(rid, phash, psize, refid)
        return r
    
    def create_final_zip(self):
        # Zip all the encrypted packets into single zip (which is not encrypted)
        os.system('rm -f %s/*.zip' % self.conf.pkt_dir) # Remove any existing zip files
        #out_zip = os.path.join(self.conf.pkt_dir, self.pktconf['rid']) 
        out_zip = os.path.join('/tmp', self.pktconf['rid']) 
        final_zip = shutil.make_archive(out_zip, 'zip', ZIP_IN_DIR)
        return final_zip

    def create_wrapper_json(self, fpath):
        '''
        Creates json for an encrypted subpacket.
        Inputs:
          fpath: Path of the encrypted zip file
        '''
        filename = os.path.basename(fpath)
        dirname = os.path.dirname(fpath)
        packetname = filename.split('.')[0]
        h = hashlib.sha256()
        h.update(open(fpath, 'rb').read()) 
        encrypted_hash = h.digest() # bytes
        b64_s = base64.urlsafe_b64encode(encrypted_hash).decode()  # convert to str
        b64_s = b64_s.replace('=', '') # Remove any trailing = chars
        templ = {     
            "process":"NEW", 
            "creationdate": self.pktconf['creation_date'],  
            "encryptedhash": b64_s,
            "signature": "",
            "id": self.pktconf['rid'],
            "source":"REGISTRATION-CLIENT",
            "providerversion":"v1.0",
            "schemaversion":"0.0",
            "packetname": packetname,
            "providername":"PacketWriterImpl"
        } 
        
        s = json.dumps(templ)
        out_path = os.path.join(dirname, packetname + '.json')
        fp = open(out_path, 'wt')
        fp.write(s)
        fp.close()

def main():

    app = App(conf)
    app.cleanup()

    refid = app.pktconf['center_id'] + '_' + app.pktconf['machine_id']
    mosip = MosipSession(app.conf.server, app.conf.user, app.conf.password, ssl_verify=conf.ssl_verify)

    app.update_conf(mosip)

    app.template_to_packets()
    app.update_hashes()

    zipped_pkts = app.zip_packets()

    os.makedirs(ENC_DIR)
    for zipped_pkt in zipped_pkts:
        out_path = mosip.encrypt_packet(zipped_pkt, ENC_DIR, os.path.basename(zipped_pkt), refid)
        app.create_wrapper_json(out_path)

    unenc_zip = app.create_final_zip()

    enc_zip = mosip.encrypt_packet(unenc_zip, app.conf.pkt_dir, os.path.basename(unenc_zip), refid)
 
    print('\n=== Syncing packet === \n')
    r = app.sync_packet(mosip, enc_zip, refid) 
    print_response(r) 
    r = response_to_json(r)
    rid = r['response'][0]['registrationId']
    fp = open('rid.out', 'a')
    fp.write('%s\n' % rid) 
    fp.close()

    print('\n=== Uploading packet === \n')
    r = mosip.upload_packet(enc_zip)
    print_response(r)


if __name__=="__main__":
    main()
