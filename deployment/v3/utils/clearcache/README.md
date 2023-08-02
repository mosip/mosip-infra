# CLEAR CACHE AND UNUSED IMAGES FROM NODES

1. ssh into the node 

   `ssh -i <pem-key> root@<ip of the node>`

2. run the script

   `./clearcache.sh`

3. If you want to clear the cache automatically, edit the crontab using crontab -e and set the cron time. 
   For example, to run the script every minute:

   `* * * * * /bin/bash /root/clearcache.sh`

### NOTE: Please make sure to replace <pem-key> and <ip-of-the node> with the actual values specific to your environment. Additionally, remember to provide the correct path to the clearcache.sh script in the crontab entry if it's located elsewhere.
   