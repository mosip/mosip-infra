#!/bin/python3.6
# Kill running service and runs it again
#./run_service.py  service_name

import sys
sys.path.insert(0, '../')
from config import *
from common import *

if len(sys.argv) != 2:
    print('Usage: ./run_service.py <service name>')
    exit(0)

found = False 
service_to_run = sys.argv[1].strip()
for module, service, options, suffix in MOSIP_SERVICES: 
    if service == service_to_run:
        found = True
        jar_name = get_jar_name(service, MOSIP_VERSION) 
        kill_process(jar_name)
        start_service(module, service, MOSIP_VERSION, options, suffix) 
        break

if not found:
    print('%s not found' % service_to_run)
