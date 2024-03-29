# MOSIP Deployment V3

## Overview
We provide reference implementation of a Kubernetes based **production grade** deployment of MOSIP, also called **V3 deployment**. The same may be deployed both as a **sandbox** or **full-scale production deployment**. There are two distinct parts to the installation:

* Kubernetes infra
* MOSIP components

![](docs/images/deployment_architecture.png)

## Installation
Following install sequence is recommended:
* [Kubernetes infra](https://github.com/mosip/k8s-infra)
* [External components](external/README.md)
* [MOSIP services](mosip/README.md)
* [Testrig](testrig/README.md)
* [Reporting](https://github.com/mosip/reporting/tree/develop)

## Production hardening
Refer to [production hardening checklist](docs/production-checklist.md).
