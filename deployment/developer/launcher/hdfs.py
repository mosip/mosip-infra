import subprocess
import sys
import time 
from common import *
from config import *

logger = logging.getLogger(__name__)

def run_hdfs():
    #TODO: Container stop/rm etc. needs to be much more elaborate. Multiple
    # containers may exist with same name. 
    logger.info('Running HDFS docker container')
    # Check if container already running
    cname = 'mosip_hdfs' # Container name
    # TODO: Should not really use sudo for this
    proc = subprocess.Popen('sudo docker ps --filter name=%s' % cname, 
                             shell=True, stdout=subprocess.PIPE)
    while 1:
        s = proc.stdout.readline().decode() # bytes -> str
        if len(s) == 0: # No running container with this name
            break
        if cname in s: 
            logger.info('Container already running')
            container_id = s.split()[0]
            return 
         
    proc = subprocess.Popen('sudo docker run --name %s -d sequenceiq/hadoop-docker:2.7.0' % cname, shell=True, stdout=subprocess.PIPE)
    container_id = proc.stdout.readline().strip()
    container_id = container_id.decode() # bytes -> str
    proc = subprocess.Popen('sudo docker attach %s' % container_id, stdout=subprocess.PIPE, shell=True)
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

