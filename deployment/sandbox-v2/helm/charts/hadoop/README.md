# Original chart README 
[README](CHART_README.md)

# MOSIP notes

## Taints
To run HDFS on exclusive nodes so that the pods don't get mixed up with MOSIP pods, there is "taint" defined under `group_vars.yml` `hdfs:nodeAffinity`.  Accordingly, changes have been made in statefulset templates for "tolerations" and "nodeAffinity".  Note that currently we can exclusively assign all HDFS pods to single node only.  So even the replications run on the same node.  This may be fine for a sandbox setup, but does not emulate production.  If you want to run HDFS pods on multiple exclusive nodes, some modification in the code related to taints and tolerations is needed.
