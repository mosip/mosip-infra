# key-migration-utility

Helm chart for installing Kernel module key-migration-utility.

## TL;DR

```console
$ helm repo add mosip https://mosip.github.io
$ helm install my-release mosip/key-migration-utility
```

## Introduction

The helm chart here essentially contains job that helps to migrate keys from any keystore type to any other supported format.

Keymanager facilitates various keystore types, including `PKCS11`, `PKCS12`, `JCE`, and `offline`.

**Note :** The offline keystore type is not compatible with keymigration operations.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure
- ReadWriteMany volumes for deployment scaling

## Installing the Chart

To install the chart with the release name `key-migration-utility`.

```console
helm install my-release mosip/key-migration-utility
```

The command deploys key-migration-utility on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```
The command removes all the Kubernetes components associated with the chart and deletes the release.

