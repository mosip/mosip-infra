This chart contains all the Registration Processor services that run on the MZ (Military Zone) or Secure zone cluster.  The services that run on the DMZ (De-Militarised Zone) are available as a separate chart "dmzregproc".

* Readiness probe:
The probe has been disabled for now because the pods looks for hazelcast headless service, which in turn does not connect to the pod because it is still not up!  So this is chicken and egg problem, circular dependency. However, liveness probe has been retained as by that time the pod is up. So if anything fails in bringing up the stage, it will show up when liveliness probe kicks.  Recommended that the state of all stages is checked after the initial time delay set for liveliness probe.

TODO: ABIS middleware probes have been disabled, not working.
TODO: Temporarily Liveness probe has be disabled due to load issues.

* Services and stages.  Not all stages have service front end. Biometric dedupe and print has a stage as well as a service.

Add notes:
* Hazelcast: all stages should have component for hazelcast discovery
* Stage logs should show all the stages connected (a number is shown)
* Sequence of order in which stages are brought up does not matter.

* Services and stages.  Not all stages have kubenetes front end service. Stages that are also being used as service also:
1. Packet receiver stage
1. Manual verification stage
1. Secure zone notification stage


* Biometric dedupe and print has a stage as well as a service.
