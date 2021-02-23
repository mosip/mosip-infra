#!/bin/python3
# Utility to decode tokens with missing = padding
import base64 
import sys

data = sys.argv[1]

data = data.split('.')
for d in data[0:2]:
    r = base64.b64decode(d + '=' * (-len(d) % 4))
    print('')
    print(r.decode())


