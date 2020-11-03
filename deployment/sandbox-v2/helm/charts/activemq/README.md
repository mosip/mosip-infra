This chart is there for installing the activemq in the mz cluster and enabling its web console to be accessed from outside.

Container used: Modified version of `fogsyio/activemq:5.15.9` saved as `mosipdev/activemq:5.15.9`

Modification: In `conf/jetty.xml` the admin url has been modified to `/activemq/admin`.

Note that in this docker we cannot easily change the admin password.  Need to figure out a good way to do this, like pass with an env variable.

---
Earlier the following container was used that looks more elaborate but we could not modify the default admin webconsole path in it (looks like it creates conf and conf.tmp directory fresh from somewhere):

ActiveMQ config xml has parameters for temp memory usage, but these parameters are not getting set with the docker environment variables mentioned here:

https://hub.docker.com/r/webcenter/activemq

I did not see any code inside the docker that actually reads these environment variables and modifies the config XML. For now we will perhaps disable the ERROR messages generated because of lack of storage memeory on node. Check filebeat config, where such filters are added.
