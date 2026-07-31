# UITESTRIG

## Introduction
UITESTRIG will test end-to-end functional flows involving multiple UI modules.

## Install
* Install
```sh
./install.sh [kubeconfig]
```

Prompts can be skipped by exporting env vars first, for example:

```sh
export time=3 flag=Y
export env=https://injiweb.dev.mosip.net/
export injiWebUi=https://injiweb.dev.mosip.net/
export TEST_URL=https://admin.dev.mosip.net/
export token=<google-refresh-token>
export client_id=<google-client-id>
export secret=<google-client-secret>
export User_name=<browserstack-user>
export Access_key=<browserstack-key>
export Env_user=api-internal.dev
export db_port=5433
./install.sh /path/to/dev.config
```

### Deploy to MOSIP `dev` (`*.dev.mosip.net`)

Use the non-interactive installer:

* [uitestrig-dev](../uitestrig-dev/README.md)

Or trigger Helmsman on [mosip/infra](https://github.com/mosip/infra) branch `dev` (workflow **Deploy Testrigs of mosip using Helmsman**, mode `apply`).

## Uninstall
* To uninstall UITESTRIG, run `delete.sh` script.
```sh
./delete.sh
```

## Run UITESTRIG manually

#### CLI
* Download Kubernetes cluster `kubeconfig` file from `rancher dashboard` to your local.
* Install `kubectl` package to your local machine.
* Run UITESTRIG manually via CLI by creating a new job from an existing k8s cronjob.
  ```bash
  kubectl --kubeconfig=<k8s-config-file> -n uitestrig create job --from=cronjob/<cronjob-name> <job-name>
  ```
  example:
  ```bash
  kubectl --kubeconfig=/home/xxx/Downloads/dev.config -n uitestrig create job --from=cronjob/cronjob-uitestrig cronjob-uitestrig
  ```
