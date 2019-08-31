import subprocess
import sys
from common import *
from config import *

logger = logging.getLogger(__name__)

def install_clamav():
    logger.info('Installing CLAMAV')
    command('sudo yum -y install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd')
    if not os.path.exists('/etc/clamd.d/scan.conf.original'): 
        command('sudo cp /etc/clamd.d/scan.conf /etc/clamd.d/scan.conf.original') 
    command('sudo sed -i -e "s/^Example/#Example/" /etc/clamd.d/scan.conf')
    command('echo "LocalSocket /var/run/clamd.scan/clamd.sock" | sudo tee -a /etc/clamd.d/scan.conf')
    command('sudo sed -i -e "s/^Example/#Example/" /etc/freshclam.conf')
    command('sudo systemctl enable clamd@scan') 
    run_clamav()

def run_clamav():
    command('sudo freshclam')
    command('sudo systemctl start clamd@scan') 

def restart_clamav():
    logger.info('Restarting Clamav')
    command('sudo systemctl restart clamd@scan') 
