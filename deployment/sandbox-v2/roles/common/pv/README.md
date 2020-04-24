This role creates a folder on a host and creates persistent volume (pv) for it. 

Parameters:
* pv_name: persistent volume name
* pv_path: storage folder path
* pv_size: size of allocation e.g. 1Gi, 10Mi  
* pv_node_hostname: Name of the host on which the folder exists.  This is needed to provide affinity to the pod using this pv.
 

