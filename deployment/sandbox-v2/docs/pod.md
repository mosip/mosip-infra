## Pod replication

For production setups you may want to replicate pods more than the default replication factor of 1.  Update `podconfig.yml` for the same.  You may create a separate file for production and point to it from `group_vars/all.yml --> podconfig_file`. 

