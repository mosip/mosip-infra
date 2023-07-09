# Partner Management Service 115-120 Migration Utility

## Install
* Run `./install.sh` to deploy `pms-migration-utility`.
  ```
  $ ./install.sh
  ```
* The script will prompt to run the `pms-migration-utility` as Cronjob. If the input provided is `Y`, then the script will deploy `pms-migration-utility` as Cronjob otherwise the script will deploy `pms-migration-utility` as a job.
* For Cronjob, the script will prompt to provide hour (X) to run the cronjob in every X hr.
* Use the below command to run the `pms-migration-utility` Cronjob manually.
  ```
  NS=pms-migration-utility
  kubectl -n $NS create job --from=cronjob/cronjob-pms-migration-utility pms-migration-utility
  ```