#!/bin/python3.6
# Kill running service and runs it again
#./run_service.py  service_name

import sys
sys.path.insert(0, '../')
from config import *
from common import *

if len(sys.argv) != 2:
    print('Usage: ./run_service.py <service name>')
    print('service name: Name of service as in config.py.') 
    print('If there are multipleservices with same name like "registration-processor-common-camel-bridge" then all are stopped and re-run')
    exit(0)

found = False 
service_to_run = sys.argv[1].strip()
matches = [] 
for module, service, options, suffix in MOSIP_SERVICES: 
    if service == service_to_run:
        matches.append((module, service, options, suffix)) 

for module, service, options, suffix in matches: 
    jar_name = get_jar_name(service, MOSIP_VERSION) 
    kill_process(jar_name)

for module, service, options, suffix in matches: 
    start_service(module, service, MOSIP_VERSION, options, suffix) 

if len(matches) == 0: 
    print('%s not found' % service_to_run)
