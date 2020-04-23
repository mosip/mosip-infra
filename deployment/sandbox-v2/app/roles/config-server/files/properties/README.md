Since are working with 2 kubernetes clusters - mz and dmz, for registration process we have to replicate the property files with a suffix -dmz.

Suffix:
* MZ (secure cluster): -qa
* DMZ : -dmz


Properties for secure zone hazelcast have been duplicated as -dmz.  Earlier hazelcast dmz assumed docker containers, not kubernetes.

Similarly registration-processor-qa.properties has been replicated to registration-processor-dmz.properties.  Some of the links in the latter point to MZ cluster, hence the links are different.

