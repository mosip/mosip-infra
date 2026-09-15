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
* [dsl-dev](dsl-dev/README.md) — deploy **dslorchestrator** into namespace **`dsl-dev`**, using existing **packetcreator** in **`packetcreator-dev`**
* [dev](dev/README.md) / [qajava21-dev](qajava21-dev/README.md) — older combined helpers (prefer `dsl-dev` when packetcreator-dev already exists)

## Delete
* Follow the steps mentioned in the below links to uninstall DSLRIG.
    * [DSLRIG](dslrig/README.md#uninstall)
    * [Authdemo](authdemo/README.md#uninstall)
    * [Packetcreator](packetcreator/README.md#uninstall)
* Follow the steps mentioned in the below links to uninstall ApiTestrig.
    * [Authdemo](authdemo/README.md#uninstall)
    * [Apitestrig](apitestrig/README.md#uninstall)
