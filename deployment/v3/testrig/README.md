# TESTRIG

## Overview
The steps here install Testrig components, which include APITESTRIG and DSLRIG.
These components are used to test the working of APIs of MOSIP modules and the end-to-end functional flows involving multiple MOSIP modules.

## APITESTRIG Install
Install in the following order:
* [Authdemo](authdemo/README.md)
* [Apitestrig](apitestrig/README.md)

## DSLRIG Install
Install in the following order:
* [Packetcreator](packetcreator/README.md)
* [Authdemo](authdemo/README.md)
* [DSLRIG](dslrig/README.md)

### Environment-specific installers
* [dev](dev/README.md) — packetcreator + dslrig on `dev.mosip.net` (`installation-name: dev` in `default` namespace)
* [qajava21-dev](qajava21-dev/README.md) — packetcreator + dslrig on `qajava21.mosip.net` with `dev` space in `default` namespace

## Delete
* Follow the steps mentioned in the below links to uninstall DSLRIG.
    * [DSLRIG](dslrig/README.md#uninstall)
    * [Authdemo](authdemo/README.md#uninstall)
    * [Packetcreator](packetcreator/README.md#uninstall)
* Follow the steps mentioned in the below links to uninstall ApiTestrig.
    * [Authdemo](authdemo/README.md#uninstall)
    * [Apitestrig](apitestrig/README.md#uninstall)
