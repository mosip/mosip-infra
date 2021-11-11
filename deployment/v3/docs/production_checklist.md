# Production deployment checklist

1. Change log level to INFO in application properties.
1. Enabled persistence in all modules.  On cloud change the storage class from 'Delete' to 'Retain'.
2. Make sure storage class allows expansion of storage.
3. Review size of persistent volumes and update.
4. Set up backup for Longhorn.
5. Disable registration processor External Stage if not required.
6. Set rate control (throttling) parameters for PreReg.
7. Reprocessor cronjob frequency and other settings
8. All cronjobs timings according to the country (check property files)
9. Valid urls redirect in Keycloak - set specific urls.
10. Keycloak Realm connection timeout settings - review all.
11. Postgres [production configuration](../profiles/production/postgres/values.yaml)
