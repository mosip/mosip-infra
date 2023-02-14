# Overview

This is a dockerized cron job that performs the following:

* Checks if below mentioned 3 probes are allocated to the services:
   * startup probe
  *  readiness probe
  *  liveness probe
* Shows the images used for every deployment in the cluster across the namespaces.
* Shows the necessary label details of each image used in deployment.


## Install

* Install
```sh
./install.sh
```

