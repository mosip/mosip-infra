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

def create_user(container_id, user):
    '''
    Create users and directories
    '''
    command('docker exec -it %s useradd %s' % (container_id, user))
    command('docker exec -it %s /usr/local/hadoop/bin/hdfs dfs -mkdir /user/%s' % (container_id, user))  
    command('docker exec -it %s /usr/local/hadoop/bin/hdfs dfs -chown -R %s:%s /user/%s' % (container_id, user, user, user)) 

def run_hdfs():
    logger.info('Running HDFS docker container')
    cname = 'mosip_hdfs' # Container name

    if is_container_running(cname):
        logger.info('Container is already running')
        return  

    container_id = get_container_id(cname)
    new_container = container_id is None 

    if not new_container:  # Container already exists 
        logger.info('Container exists. Starting it..')
        command('docker container start %s' % container_id)     
    else: # Run fresh
        cmd = 'docker run -p 50070:50070 -p 9000:9000 -p 50075:50075 -p 50010:50010 -p 50020:50020 -p 50090:50090 --name %s -d sequenceiq/hadoop-docker:2.7.0' % cname 
        proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
        container_id = proc.stdout.readline().strip()
        container_id = container_id.decode() # bytes -> str

    # Attach to a running container
    print('attaching container')
    proc = subprocess.Popen('docker attach %s' % container_id, stdout=subprocess.PIPE, shell=True)
    while 1: 
        s = proc.stdout.readline().decode() # bytes -> str
        if s.find('starting nodemanager') != -1: 
            break
        time.sleep(1) 
    logger.info('HDFS started')
    t = 30
    logger.info('Waiting for %d seconds for all processes to start up' % t)
    time.sleep(t)  # TODO: Wait like this is not good. 
    if new_container: 
        logger.info('Creating users')
        create_user(container_id, 'regprocessor')
        create_user(container_id, 'prereg')
        create_user(container_id, 'idrepo')

    return container_id

def stop_hdfs(container_id):
    logger.info('Stopping HDFS docker container')
    command('sudo docker container stop %s' % container_id)

