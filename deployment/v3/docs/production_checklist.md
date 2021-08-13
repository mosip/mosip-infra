# Production deployment checklist

1. Change log level to INFO in application properties.
1. Enabled persistence in all modules.  On cloud change the storage class from 'Delete' to 'Retain'.
1. Review size of persistence and update.
1. Set up backup for Longhorn.
1. Disable registration processor External Stage if not required.
1. Set rate control (throttling) parameters for PreReg.
1. Reprocessor cronjob frequency and other settings
1. All cronjobs timings according to the country (check property files)
