## Introduction

RESTART_CRON chart deploys a CronJob that runs on a schedule specified in the [restart-cron.yml](https://github.com/mosip/mosip-infra/blob/1.1.5.5/deployment/sandbox-v2/playbooks/restart-cron.yml)
The CronJob restarts deployments in the specified namespaces using the kc1 rollout restart command and waits for them to reach the desired state using the kc1 rollout status command..

For now this cronjob is being used to restart idgenerator service which will restart every four hour in a cluster.