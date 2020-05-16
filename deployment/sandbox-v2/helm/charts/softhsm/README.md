Softhsm is a simulation of HSM and will not be used in production.  It is an out-of-MOSIP infratructure component within sandbox, and hence been provided as a separate helm chart.

The chart here depends on softhsm folder initialied with conf file prior to running this chart.  This is done via Ansible role 'softhsm'.

