#script to clearcache and unused images from the nodes

#!/bin/bash

echo "Clearing cache..."
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
echo "Cache cleared."

free -h

echo "Remove unused docker images"
sudo docker system df
sudo docker system prune -a -f

echo "Cache and unused image cleanup completed."