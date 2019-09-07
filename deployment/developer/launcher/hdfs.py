import subprocess
import sys
import time 
from common import *
from config import *

logger = logging.getLogger(__name__)

def is_container_running(container_name):
    proc = subprocess.Popen('docker ps --filter name=%s' % container_name, 
                             shell=True, stdout=subprocess.PIPE)
    while 1:
        s = proc.stdout.readline().decode() # bytes -> str
        if len(s) == 0: # All output is read
            return False 
        if container_name in s: 
            container_id = s.split()[0]
            return True 

def get_container_id(container_name):
    proc = subprocess.Popen('docker container ls -a | grep %s ' % 
                             container_name, shell=True, stdout=subprocess.PIPE)
    s = proc.stdout.readline().decode() # bytes -> str
    if len(s) == 0:  # Not found
       return None

    return s.split()[0]  # Container id

def run_hdfs():
    #TODO: Container stop/rm etc. needs to be much more elaborate. Multiple
    # containers may exist with same name. 
    logger.info('Running HDFS docker container')
    # Check if container already running
    cname = 'mosip_hdfs' # Container name
    # TODO: Should not really use sudo for this
    if is_container_running(cname):
        logger.info('Container is already running')
        return  
    container_id = get_container_id(cname)
    if container_id is not None:  # Container already exists 
        logger.info('Container exists. Starting it..')
        command('docker container start %s' % container_id)     
    else: # Run fresh
        cmd = 'docker run -p 50070:50070 --name %s -d sequenceiq/hadoop-docker:2.7.0' % cname 
        proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
        container_id = proc.stdout.readline().strip()
        container_id = container_id.decode() # bytes -> str

    proc = subprocess.Popen('docker attach %s' % container_id, stdout=subprocess.PIPE, shell=True)
    while 1: 
        s = proc.stdout.readline().decode() # bytes -> str
        if s.find('starting nodemanager') != -1: 
            break
        time.sleep(1) 
    logger.info('HDFS started')
    return container_id

def stop_hdfs(container_id):
    logger.info('Stopping HDFS docker container')
    command('sudo docker container stop %s' % container_id)

