import subprocess
import sys
import os
import shutil
from common import *
from config import *

def install_softhsm(install_dir, config_dir):
    '''
    Args:
        install_dir: Softhsm code gets downloaded and built here
        config_dir:  MOSIP config file for softhsm resides here
    '''
    logger.info('Installing SoftHSMv2') 
    cwd = os.getcwd() 
    os.chdir(install_dir)     
    command('sudo yum install -y automake autoconf libtool libtool-ltdl-devel pkg-config')
    command('git clone https://github.com/opendnssec/SoftHSMv2')
    os.chdir('SoftHSMv2')
    command('sh autogen.sh')
    command('./configure')
    command('make')
    command('sudo make install')
    os.chdir(cwd)  # Back to launcher directory

    os.makedirs(config_dir, exist_ok=True)
    shutil.copy('resources/softhsm_mosip.conf', config_dir)     

def init_softhsm(pin):
    '''
    pin should be same as what is defined in kernel.properties file
    '''
    logger.info('Initialize softhsm with key')
    command("softhsm2-util --init-token --slot 0 --pin %s --so-pin %s --label 'Keymanager_token'" %  (pin, pin))


