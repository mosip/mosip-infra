import shutil
import os
from common import *
from config import *

logger = logging.getLogger(__name__)

def install_nginx():
    logger.info('Installing nginx')
    command('sudo yum install -y nginx')
    command('sudo cp /etc/nginx/nginx.conf  /etc/nginx/nginx.conf.bak')
    command('sudo cp resources/nginx/nginx.conf /etc/nginx/')
    command('sudo systemctl restart nginx')
    # Enable nginx to access the ports
    command('sudo setsebool httpd_can_network_connect on -P')
