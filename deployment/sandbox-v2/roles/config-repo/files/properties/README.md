Since are working with 2 kubernetes clusters - mz and dmz, for registration process we have to replicate the property files with a suffix -dmz.

Suffix:
* MZ (secure cluster): -mz
* DMZ : -dmz


* Properties for secure zone hazelcast have been duplicated as -dmz.  Earlier hazelcast dmz assumed docker containers, not kubernetes.
* File name needs to have `_dmz` and `_mz`, e.g. `hazelcast_dmz-dmz.xml` as these suffixes are being searched in the code (hardcoded).

Similarly registration-processor-mz.properties has been replicated to registration-processor-dmz.properties.  Some of the links in the latter point to MZ cluster, hence the links are different.

