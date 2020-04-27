Tasks here install Hadoop multinode cluster using Helm charts. It is assumed that `helm` executable is installed before calling this role. TODO: Add it as a dependency.

The name node url would be  *-hadoop-hdfs-nn:9000.  Not that we need not specify index like *-hadoop-hdfs-nn-0:9000 (incorrect).
