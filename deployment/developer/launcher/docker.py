import logging
from common import *
from config import *

logger = logging.getLogger(__name__)

def install_docker():
    '''
    Instructions from:
    https://docs.docker.com/install/linux/docker-ce/centos/
    '''
    logger.info('Install Docker')
    command('sudo yum check-update')
    #command('curl -fsSL https://get.docker.com/ | sh')
    command('sudo yum install -y yum-utils device-mapper-persistent-data lvm2')
    command('sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo')
    command('sudo yum install -y docker-ce docker-ce-cli containerd.io')
    command('sudo usermod -a -G docker $USER') # Give access to current user
    #command('exec su -l $USER') # Don't need to logout with this
    command('sudo systemctl start docker')
    command('sudo systemctl enable docker')

def restart_docker():
    logger.info('Restarting Docker')
    command('sudo systemctl restart docker')
    command('exec su -l $USER') # TODO: permission problem without this. 
