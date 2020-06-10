import os
import sys

#rulefile = sys.argv[1]
batch = sys.argv[1]
file = open(batch, 'r')
count = 0

# Using for loop
for line in file:
    count += 1
    tag = (line.strip().split("/"))
    name = tag[-1].split(".")
    path = line.strip()
    batchname=batch.split(".")
    bname = batchname[0]
    print (bname)
    print("--------------------------- Scanning GitHub Repo:  " +name[0]+ " -----------------------------------")
    os.system('trufflehog3 -v --no-entropy --no-history -r '+rulefile+' '+path+' -f html -o ./Reports_`date +%d%b%y`'+bname+'/mosip'+name[0]+'.html')
# Closing files
file.close()
