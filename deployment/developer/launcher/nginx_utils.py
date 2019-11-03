import shutil
import os
from common import *
from config import *

logger = logging.getLogger(__name__)

def install_ssl():
    '''
    Note that domain name mentioned on this certificate is 'localhost'.
    If you are accessing the machine from outside, create a new one
    using the IP/domain name of the machine.  Procedure:
    https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-on-centos-7
    '''
    command('sudo mkdir -p /etc/ssl/private') 
    command('sudo chmod 700 /etc/ssl/private') 
    command('sudo cp resources/nginx/nginx-selfsigned.crt /etc/ssl/certs') 
    command('sudo cp resources/nginx/nginx-selfsigned.key /etc/ssl/private')

def install_nginx():
    logger.info('Installing nginx')
    command('sudo yum install -y nginx')
    command('sudo cp /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak')
    command('sudo cp resources/nginx/nginx.conf /etc/nginx/')
    command('sudo systemctl restart nginx')
    install_ssl()
    # Enable nginx to access the ports
    command('sudo setsebool httpd_can_network_connect on -P')
    restart_nginx()

def restart_nginx():
    command('sudo systemctl restart nginx')
