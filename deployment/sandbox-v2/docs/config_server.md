## Config server

Configurations for all modules are specified via property files located in Github repository. For example, for this sandbox the properties are located at `https://github.com/mosip/mosip-config` within `sandbox` folder. You may have your own repository with a folder containing property files. The repo may be private on Github. Configure the following parameters in `group_vars/all.yml` as below (example):
```
config_repo:
  git_repo_uri: https://github.com/mosip/mosip-config 
  version: 1.1.2
  private: false 
  username: <your github username>
  search_folders: sandbox 
  local_git_repo:
    enabled: false
```

If `private: true` then update your Github username as above in `group_vars/all.yml`.  Update your password in `secrets.yml`:
```
config_repo:
    password: <YOUR GITHUB PASSWORD>
```

If `local_git_repo` is enabled, the repo will be cloned to the NFS mounted folder and config server will pull the properties locally. This option is useful when sandbox is secured with no Internet access. You may git check-in any changes locally.  However, note that if you want the changes to reflect in the parent Github repo, you will have to push them manually.  There is no need to restart config-server pod when you make changes in the config repo.
  
If you have modified default passwords in `secrets.yml`, generate the ciphers of these passwords and update property files for the changed passwords. The ciphers may be generated from the console machine after the config server is up using the following `curl` command:
```
$  curl http://mzworker0.sb:30080/config/encrypt -d  <string to be encrypted>
```
The above command connects to config server pod on MZ cluster via ingress.
You may also use script [here](../utils/secrets) to encrypt all secrets at once.

