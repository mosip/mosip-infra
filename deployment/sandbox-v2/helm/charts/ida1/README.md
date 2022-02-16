## Softhsm
IDA connects to softhsm.  Each IDA service connects to corresponding softhsm (1-1).  So before running each IDA service we have to run softhsm instance.  See role/softhsm  and playbooks/softhsm.yml for more details.

Note that we have not combined the softhsm installation has part of this Helm package, as softhsm in not part of IDA.  In production, there won't be any softhsm, but an actual hardware HSM.  

## Interdependencies
Following is the sequence of IDA pod exectution:

1.  Generator jobs
1.  id-auth-service
1.  Other services

Generator jobs are run before using annotation  
    ```
    "helm.sh/hook": pre-install`
    "helm.sh/hook-delete-policy": hook-succeeded
    ```

The second annotation ensures these jobs get deleted on `helm delete`

Dependency between services is ensure using kubernetes `initContainers`.

