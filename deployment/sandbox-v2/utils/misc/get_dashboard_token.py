#!/usr/bin/python
# Given a kube config file, pull out the dashboard token.  The token is 
# needed to login into the dashboard.
# Usage: ./get_dashboard_token <kube config path> 
# Output: Token string on stdout 

import subprocess
import sys

if len(sys.argv) != 2:
  print('Usage: get_dashboard_token <kube config path>')
  exit(0)

kubeconfig = sys.argv[1]

out = subprocess.check_output("kubectl --kubeconfig %s -n kubernetes-dashboard describe secret $(kubectl --kubeconfig %s -n kubernetes-dashboard get secret | grep ^admin-user | awk '{print $1}')" % (kubeconfig, kubeconfig), shell=True)

lines = out.split('\n')

for line in lines:
  if line.startswith('token: '):
    print(line.split()[1])
