import logging
from logging.handlers import RotatingFileHandler
import os
import sys

# log_level to be specified 'info', 'error', 'debug', 'warning' 
def init_logger(logger, file_path, max_bytes, log_level, nfiles):
    dirname = os.path.dirname(file_path)    
    if dirname:
        if not os.path.exists(dirname):
            os.makedirs(dirname)

    log_level_map = {'info' : logging.INFO, 'error' : logging.ERROR, 
                     'debug' : logging.DEBUG, 'warning' : logging.WARNING}
    logger.setLevel(logging.DEBUG)  # Set to lowest level

    # Add Rotating file handler
    fh = RotatingFileHandler(file_path, maxBytes = max_bytes, backupCount = nfiles)
    fh.setLevel(log_level_map[log_level])
    formatter = logging.Formatter('[%(asctime)s][%(name)s][%(levelname)s]: %(message)s')
    fh.setFormatter(formatter)
    logger.addHandler(fh)

    # Add stdout handler
    fs = logging.StreamHandler(sys.stdout)
    fs.setLevel(log_level_map[log_level])
    fs.setFormatter(formatter)
    logger.addHandler(fs)

    return logger

