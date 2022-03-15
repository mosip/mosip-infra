import subprocess
import logging
import os
from config import *

logger = logging.getLogger(__name__)


def command(cmd):
    r = subprocess.run(cmd, shell=True)
    if r.returncode != 0:
        logger.error(r)


def get_jar_name(service, version):
    return service + '-' + version + '-SNAPSHOT.jar'


def run_jar(jar_dir, jar_name, logs_dir, config_port,
            max_heap_size=JAVA_HEAP_SIZE, add_options='',
            log_suffix=''):
    '''
    Args:
        add_options:  Any additional options in the for '-D<option>'
        log_suffix: Suffix to be added to log file name. Useful when mutliple
            instances of same service are run 
    '''
    logger.info('Running jar %s' % jar_name)
    cwd = os.getcwd()
    os.chdir(jar_dir)
    options = [
        '-Dspring.cloud.config.uri=http://localhost:%d' % config_port,
        '-Dspring.cloud.config.label=master',
        '-Dspring.profiles.active=dev',
        '-Xmx%s' % max_heap_size,
        add_options
    ]
    cmd = 'java %s -jar %s >>%s/%s.server%s.log 2>&1 &' % (' '.join(options),
                                                           jar_name, logs_dir,
                                                           jar_name,   log_suffix)
    logger.info('Command: %s' % cmd)
    command(cmd)
    logger.info('%s run in background' % jar_name)
    os.chdir(cwd)


def kill_process(search_str):
    '''
    Search a process whos command contains search_str and kill it.
    The command line arguments of a command are concatenated into a string 
    for easy searching. The char used for concatenation is unlikely char like
    #.
    '''
    import psutil  # Moved here in case module not found during launcher load
    for p in psutil.process_iter():
        pinfo = p.as_dict(attrs=['pid', 'cmdline'])
        if search_str in '#'.join(pinfo['cmdline']):
            p.kill()
