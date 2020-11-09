# TPM for Reg Client

By default, sandbox installs [Reg Client Downloader](https://github.com/mosip/mosip-infra/blob/1.1.2/deployment/sandbox-v2/playbooks/reg-client-downloader.yml) with Trusted Platform Module (TPM) disabled.  To enable TPM so that you use trusted private/public keys of the reg client machines, do the following:

1. Update the reg client downloader tpm environment variable:
    ```
    File: helm/charts/reg-client-downloader/values.template.j2

    Change:
    tpm: "Y"
    ```
1. If you have done the above before installing the sandbox, then you may skip to the last step.
1. If reg client downlaoder is already running on your sandbox, delete and restart it as below:
    ```
    $ helm2 delete reg-client-downloader 
    (Wait for all resources to get terminated)
    $ sb
    $ an playbooks/reg-client-downloader.yml
    ``` 
1. Download the reg client from `https://<sandbox domain name>/registration-client/1.1.2/reg-client.zip`


