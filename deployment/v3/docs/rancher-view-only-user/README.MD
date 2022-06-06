# Rancher View only user



## Add view only user on cluster API using rancher



Rancher, by default, has `Owner`, `Member`, and `Custom` cluster permission, but none of these grants read-only to a user. 

## Prerequisite, 

   * You need to have admin access on the rancher itself (this is separate from the cluster-admin). 

## Create View only user

Login as admin, go to `Users & Authentication` under `Configuration` -> `Create Cluster Role`
    
    * Name: give a name for a role i.e., view-only 
    * Under Grat Resources, select `get`, `list`, and `watch` as verbs and `*` for `Resources` and `API Groups`

Save newly created role, and role `view_only` will be displayed as part of defined roles when adding a user to the cluster.


![](img/rancher_role.png)