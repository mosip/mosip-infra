import os

file = open('list.txt', 'r')
count = 0

# Using for loop
for line in file:
    count += 1
    tag = (line.strip().split("/"))
    name = tag[-1].split(".")
    path = line.strip()
    print("--------------------------- Scanning GitHub Repo:  " +name[0]+ " -----------------------------------")
    os.system('trufflehog3 -v --no-entropy --no-history -r rules_mosip.yaml '+path+' -f html -o ./Reports_`date +%d%b%y`/mosip'+name[0]+'.html')
# Closing files
file.close()