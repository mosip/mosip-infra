# HSM

Hardware Security Module (HSM) stores the cryptographic keys used in MOSIP.  In production deployment HSM would be installed extremely securily and accessed from MOSIP modules.  However, for development and testing we use [Softhsm](softhsm/README.md) that installs as a pod in the Kubernetes cluster.
