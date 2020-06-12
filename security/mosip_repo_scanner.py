import os
import sys

rulefile = sys.argv[1]
batch = sys.argv[2]
config = sys.argv[3]

file = open(batch, 'r')
count = 0
# Using for loop
for line in file:
    count += 1
    tag = (line.strip().split("/"))
    name = tag[-1].split(".")
    path = line.strip()
    tag2=batch.split("/")
    bname = tag2[-1].split(".")
    batchname = bname[0]
    print("--------------------------- Scanning GitHub Repo:  " +name[0]+ " -----------------------------------")
    os.system('trufflehog3 -v -c '+config+' -r '+rulefile+' '+path+' -f html -o ./Reports_`date +%d%b%y`_'+batchname+'/mosip-'+name[0]+'.html')
# Closing files
file.close()
