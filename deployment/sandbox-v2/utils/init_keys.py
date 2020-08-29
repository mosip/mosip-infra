#!/bin/python3
# Script to initialize master keys for Keyamanager. Run this script after
# keymanager is installed. Note that initialization of the keys in this 
# fashion is only for development/sandbox environments.  In production, these
# keys will be created on HSM in a very trusted environment with authorized 
# personnel. 
# Usage: ./init_keys.py <sandbox domain name>  
# TODO: This is a temporary arrangement.  Move to docker based init.
import sys
import subprocess
import traceback
sys.path.insert(0, '../test/regproc')
sys.path.insert(0, 'test/regproc')
from common import MosipSession

def main():

    if len(sys.argv) != 2:
        print('Usage: ./init_keys.py <sandbox domain name>')
        return 1

    # Username and password hardcode here as they are expected to exist
    # if keycloak init is done
    mosip = MosipSession(sys.argv[1], '110127', 'Techno@123') 
    try:    
        mosip.generate_master_key('ROOT', 'MOSIP') 
        mosip.generate_master_key('KERNEL', 'MOSIP-KERNEL-SIGN', 'SIGN') 
        mosip.generate_master_key('KERNEL', 'MOSIP-KERNEL') 
        mosip.generate_master_key('REGISTRATION', 'MOSIP-REGISTRATION') 
        mosip.generate_master_key('PRE_REGISTRATION', 'MOSIP-PRE_REGISTRATION') 
        mosip.generate_master_key('REGISTRATION_PROCESSOR', 'MOSIP-REGISTRATION_PROCESSOR') 
        mosip.generate_master_key('ID_REPO', 'MOSIP-ID_REPO') 
    except Exception:
        traceback.print_exc(file=sys.stdout)
        return 1

    return 0


if __name__=="__main__":
    main()
