# Production deployment checklist

1. Change log level to INFO in application properties.
1. Enable persistence in all modules.  On cloud change the storage class from 'Delete' to 'Retain'.  If you already have PV as 'Delete', you can edit the PV config and change it to 'Retain' (without having to change storage class)
2. Make sure storage class allows expansion of storage.
3. Review size of persistent volumes and update.
4. Increase the number of nodes in the cluster according to expected load.  
5. Set up backup for Longhorn.
6. Disable registration processor External Stage if not required.
7. Set rate control (throttling) parameters for PreReg.
8. Reprocessor cronjob frequency and other settings
9. All cronjobs timings according to the country (check property files)
10. Valid urls redirect in Keycloak - set specific urls.
11. Keycloak Realm connection timeout settings - review all.
12. Postgres [production configuration](../profiles/production/postgres/values.yaml)
13. Disable '111111' default OTP.
14. Review idschema attribute names again name is Datashare policy and Auth policy for any partner (including IDA).
15. Review attributes specified in `ida-zero-knowledge-unencrypted-credential-attributes`
16. Review 1id-authentication-mapping.json` in config vis-a-vis attribute names in idschema
17. Scripts to clean up processed packets in landing zone.
18. On-prem K8s cluster production configuration as given [here](rke_cluster_hardening.md).
19. Increase `replicaCount` for Clamav.
20. Kafka: disable option to delte a topic: [`deleteTopicEnable: false`](../external/kafka/values.yaml)

