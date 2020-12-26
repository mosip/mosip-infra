#!/bin/python3
# Usage: (Example)
# $ ./get_dashboard_token.py ~/.kube/mzcluster.config admin-user ./tmp/mz_dashboard_admin.token
# $ ./get_dashboard_token.py ~/.kube/mzcluster.config view-user ./tmp/mz_dashboard_view.token

import subprocess
import sys
import traceback
import argparse

SERVICE_ACCOUNTS = ['admin-user', 'view-user']

def get_dashboard_token(service_account, kubeconfig):
    out = subprocess.check_output("kubectl --kubeconfig %s -n kubernetes-dashboard describe secret $(kubectl --kubeconfig %s -n kubernetes-dashboard get secret | grep ^%s| awk '{print $1}')" % (kubeconfig, kubeconfig, service_account), shell=True)
    out = out.decode() # bytes -> str
    token = '' 
    lines = out.split('\n')
    for line in lines:
        if line.startswith('token: '):
            token = line.split()[1]
    return token

def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('kubeconfig', type=str, help='Path to kubectl config file')
    parser.add_argument('service_account', type=str, help='admin-user|view-user')
    parser.add_argument('outfile', type=str, help='Token output file path')
    args = parser.parse_args()
    return args, parser

def main():
    args, parser =  args_parse()
    if args.service_account not in SERVICE_ACCOUNTS:
        parser.print_help()
        sys.exit(1)
    try:
        token = get_dashboard_token(args.service_account, args.kubeconfig)
        fp = open(args.outfile, 'wt')
        fp.write(token)
        fp.write('\n')
        fp.close()
    except:
        formatted_lines = traceback.format_exc()
        print(formatted_lines)
        sys.exit(2)
    sys.exit(0)

if __name__=="__main__":
    main()
