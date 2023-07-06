# Partner Management Service 115-120 Migration Utility

## Install
* Run `./install.sh` to deploy pms-migration-utility.
  ```
  $ ./install.sh
  ```
* The script will prompt to run pms-migration-utility as cronjob,
  If provided `Y` then the script will deploy pms-migration-utility as cronjob otherwise script will deploy pms-migration-utility as job.
* For cronjob, the script will prompt to provide hour(X) to run cronjob in every X hr.
* Use the below command to run pms-migration-utility cronjob manually.
  ```
  NS=pms-migration-utility
  kubectl -n $NS create job --from=cronjob/cronjob-pms-migration-utility pms-migration-utility
  ```