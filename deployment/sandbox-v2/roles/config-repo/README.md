The tasks here create a config repository on the node specified.  The config repo resides on on the nodes of the cluster and is mounted such that config server can access it.

The properties are populated and transfered to node, and checked-in there in a git repo.

Following is the process:

1. Update the property files with fieds.
1. Create git repo on node.
1. Transfer all property files to node.
1. Check-in the files.
