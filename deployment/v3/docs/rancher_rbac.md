# RBAC using Rancher

To set permissions to users, do the following:

Assumed that you have integrated Rancher with Keycloak.

1. Create a user in Keycloak in `master` realm with strong password
1. In Rancher, select cluster -> Projects/Namespaces
1. Move all namespaces to Project: Default. Leave namespaces under Project: System as it is.
1. Select cluster:default from topmost left dropdown. Here you have selected the Default project
1. Add a member name. Note that Keycloak is not queried to get the user name. So enter the correct name as it exists in Keycloak. 
1. Choose any role.  Read-Only for read access. In this mode a user cannot delete a pod or view any secrets.
1. Assign such roles to user projecs within the same cluster.
1. At a full cluster level (not project level) you may give permissions like 'Cluster Owner', but do this only for Admin. Very few people should have completely ownershiop.
