This chart is there for installing the activemq in the mz cluster and enabling its web console to be accessed from outside.

ActiveMQ config xml has parameters for temp memory usage, but these parameters are not getting set with the docker environment variables mentioned here:

https://hub.docker.com/r/webcenter/activemq

I did not see any code inside the docker that actually reads these environment variables and modifies the config XML. For now we will perhaps disable the ERROR messages generated because of lack of storage memeory on node. Check filebeat config, where such filters are added.
