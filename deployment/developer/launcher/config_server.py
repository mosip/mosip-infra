import subprocess
import sys
import os
import glob
import shutil
import time
from common import *
from config import *

logger = logging.getLogger(__name__)

def install_config_repo(repo_path, sftpkey):
    '''
    Args:
        sftpkey:  Name of keys in ~/.ssh used for seamless sftp  
    '''
    logger.info('Creating config git repo for config server')
    if os.path.exists(repo_path):  # Assuming it is indeed a git repo
        return 
    os.makedirs(repo_path)
    cwd = os.getcwd() 
    os.chdir(repo_path)
    command('git init') 
    # Copy all config files
    files = glob.glob(os.path.join(cwd, '../config_server/mosip_configs/*')) 
    for f in files:
        shutil.copy(f, '.')

    # Copy sftp keys from ~/.ssh (assuming they have been created before 
    # calling this function
    src = os.path.join(os.environ['HOME'], '.ssh')
    shutil.copy(os.path.join(src, sftpkey), '.')
    shutil.copy(os.path.join(src, sftpkey + '.pub'), '.')

    command('git add .')
    command('git config user.name %s' % os.environ['USER'])
    command('git config user.email %s@mosip.io' % os.environ['USER'])
    command('git commit -m "Added"')
    os.chdir(cwd)

def run_config_server(repo_path, logs_dir):
    logger.info('Running config server')
    cwd = os.getcwd() 
    os.chdir('../config_server/spring_config_server')  
    log_file = '%s/config_server.log' % logs_dir
    command('mvn -Dspring.cloud.config.server.git.uri=%s spring-boot:run >> %s 2>&1 &' % (repo_path, log_file))
    time.sleep(2) 
    f = open(log_file, 'rt')
    r = 0
    while 1:
        line = f.readline()
        if line.find('ERROR') != -1:
            logger.error('Could not start config server')
            r = 1
            break 
        if line.find('Started ConfigServiceApplication') != -1:
            logger.info('config server started')
            break  

    f.close()
    os.chdir(cwd)
    return r 

