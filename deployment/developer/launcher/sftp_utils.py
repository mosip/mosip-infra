import shutil
import os
from common import *
from config import *

logger = logging.getLogger(__name__)

def gen_keys(keyname, dst):
    '''
    Args:
        keyname: name for the RSA keys for sftp
        dst:  Desitnation directory where keys have to be moved
    '''
    logger.info('Generating SFTP keys. Give empty paraphrase')
    command('ssh-keygen -t rsa -b 4096 -f %s' % keyname)    
    shutil.move(keyname, dst)
    shutil.move(keyname + '.pub', dst)

def install_sftp(keyname):
    '''
    Args:
        keyname: name for the RSA keys for sftp
    '''
    dst = os.path.join(os.environ['HOME'], '.ssh')
    if not os.path.exists(dst):
        os.makedirs(dst)
        command('chmod 700 %s' % dst)

    gen_keys(keyname, dst)

    cwd = os.getcwd() 
    os.chdir(dst)
    command('cat %s.pub >> authorized_keys' % keyname)
    command('chmod 600 authorized_keys') 
    
    command('ssh-keyscan -H localhost >> known_hosts') 
    command('chmod 644 known_hosts') 
    
    os.chdir(cwd) # restore
