## 1. Setup a Backupstore
Setup a Amazon s3 compatible object storage separately. And this section is about how that external object storage can be linked with Longhorn to work as a backupstore (Refer [this](https://longhorn.io/docs/1.1.0/snapshots-and-backups/backup-and-restore/set-backup-target/)).

- After setting up AWS S3, create a new IAM user for with the appropriate policy set, like [this](https://longhorn.io/docs/1.1.0/snapshots-and-backups/backup-and-restore/set-backup-target/), and get the ACCESS_KEY_ID and SECRET_ACCESS_KEY pair for the IAM user.
- Create a new Kubernetes Secret, like this :
```
kubectl create secret generic <aws-secret> \
    --from-literal=AWS_ACCESS_KEY_ID=<your-aws-access-key-id> \
    --from-literal=AWS_SECRET_ACCESS_KEY=<your-aws-secret-access-key> \
    -n longhorn-system
```
- Now,
  - Specify the s3 backup target in "Longhorn-UI/Settings/General/Backup Target", like this: (region name is important)
```
s3://<your-bucket-name>@<your-aws-region>/
```
  - Specify the previously created Kubernetes Secret with the ACCESS_KEY, in "Longhorn-UI/Setttings/General/Backup Target Credential Secret"
  - Then Save Settings.
- After this step, when longhorn backup section is visited, it should already list if there are any previous present backups in the s3 storage.

## 2. Tests

#### 2.1 Trying Longhorn Volumes
- For the following test, assume only single node. After this test, it can be scaled for multiple replicas of pods and multiple replicas of volumes.
- Create a new Volume:
  - either from the UI, in "Volumes" Section.
    - Frontend: 'Block device'.\
    Access Mode : 'ReadWriteOnce'.\
    Size: 1GiB.\
    Replicas: 1
    - Then create a PVC for the Volume, from the UI.
  - Or create a PVC first, from commandline, and a new volume should be created automatically. Also bound to the pvc.
    - Specify storageClass as "longhorn". (For the name of the storageClass, get storage class list by `kubectl get sc -A`)
    - Specify the desired size: 1GiB.
- Once PVC is created;
  - Attach volume in PodSpec.
  - And in the same PodSpec, mount the above attached volume to the container.
- Example: The Following example will run a simple busybox container, which will run one command. The command checks if there is a file called "m_file" present in the mounted volume. If not present, it creates the file and writes "Something" to it. If present, then it will just print the file.
  ```
  spec:
    containers:
    - name: my-running-busybox
      image: busybox:latest
      volumeMounts:
      - name: m-volv
        mountPath: /my_dir_tmp
      command: ["/bin/sh"]
      args: ["-c", "if ! [ -f /my_dir_tmp/m_file ] ; then
                      echo Something > /my_dir_tmp/m_file;
                      while true; do
                        echo Created;
                        sleep 10;
                      done;
                    else
                      while true; do
                        cat /my_dir_tmp/m_file;
                        sleep 10;
                      done;
                    fi"]
    volumes:
    - name: m-volv
      persistentVolumeClaim:
        claimName: pvc-test-01
  ```
- Now create a second pod with the same spec. Or, if these are running in a deployment/replicaset/statefulset, then scale it to 2 replicas (Using `kubectl scale deploy/<name> --replicas=2`).
  - The first pod log should show "Created". And the second one's log should show "Something".

#### 2.2 Trying Recurring Backups & Restore after clean-reinstall

- After setting up backupstore from Sec-1.2, and after Test-2.1 is successful and running; go to the volume "Longhorn-UI/Volumes" Section. This should report to be "Healthy" and attached to the running pod(s) from Test-2.1.
- Scroll down to the section of creating "Recurring Snapshot and Backup Schedule".
  - Create a new schedule for recurring backup that executes every 5 minutes, and save. Like;
    - Type: Backup.\
      Schedule: "0/5 * * * ?".\
      Retain: 1
  - Note: A recurring backup will automatically take a snapshot before backing up.
- This will create a cronjob in longhorn-system namespace. (`kubectl get cj -n longhorn-system`) Now after the first iteration of the job, a snapshot should be created and a backup should also be created. Check Snapshots section for the volume in UI. Also check back in s3 storage for backup.
  - Note: Subsequent iterations of the job won't create any new snapshots/backups, because a new snapshot is taken only when there is new data in the volume, compared to previous snapshot (For more details, check logs of the subsequent iteration job's pod).
- At this point backups and snapshots should be working as expected.

The rest of the section is about completely removing longhorn from the cluster and reinstalling longhorn, which should effectively still show the backups. (If they are not deleted from the S3 storage.)
- First stop/delete any/all pods that are using these volumes. Then delete all volumes.
- Then go the apps section in the "Storage" Project in Longhorn-UI. Longhorn app should be listed as launched.
  - Delete Longhorn app.
  - After the app is fully removed, delete "longhorn-system" namepspace. `kubectl delete ns/longhorn-system`
  - (Optional) then delete "Storage" project in rancher-ui.
- Then go through Sec-1.1 and Sec-1.2 on this page and setup longhorn and the s3 backupstore.
- At this point, Volumes section should be empty (we havent created any new vols), but the previous backups should be listed in "Longhorn-UI/Backup" section.
- Go to the backup that is listed. And click on "Restore". Clicking restore will prompt for the details of the new volume that this is to be restored into.
- After restoration is done, a new volume should be ready for scheduling, in the Volumes section.
- Go to that new volume and create a new pv/pvc (In Create new pv/pvc section, the previously created PVC can also be used.)
- Now run 1 pod from Test-2.1, and its logs should print "Something". If it prints "Something" it means that the backup and restore is successful and it is able to read the previously created data.

## 3. Links to Concepts.

1. Longhorn Full Concepts Catalog - [here](https://longhorn.io/docs/latest/concepts/)
2. [Replicas](https://longhorn.io/docs/latest/concepts/#23-replicas) & [Snapshots](https://longhorn.io/docs/latest/concepts/#24-snapshots)
3. Backup and Restore Section - [here](https://longhorn.io/docs/latest/concepts/#3-backups-and-secondary-storage)
