kubectl get pods -A -o=jsonpath='{range .items[*]}{.metadata.namespace}{","}{.metadata.labels.app\.kubernetes\.io\/name}{","}{.status.containerStatuses[0].imageID}{","}{.status.containerStatuses[0].image}{","}{.metadata.creationTimestamp}{"\n"}' | sed 's/ /\n/g' | grep -vE 'istio*|longhorn*|cattle*|rancher|kube' | sed 's/docker\-pullable\:\/\///g' | sort -u | sed '/,,,/d' | awk -F ',' 'BEGIN {print "{ \"POD_NAME\": \"'$(echo $HOSTNAME)'\", \"DOCKER_HASH_ID\": \"'$(echo $DOCKER_HASH_ID)'\", \"k8s-cluster-image-list\": ["} {print "{"} {print "\"namespace\": \"" $1 "\","} {print "\"app_name\": \"" $2 "\","} {print "\"docker_image_id\": \"" $3 "\","} {print "\"docker_image\": \"" $4 "\","} {print "\"creation_timestamp\": \"" $5 "\"" } {print "},"} END {print "]}"}' | sed -z 's/},\n]/}\n]/g' | jq -r .  | tee -a images-list.json