# MOSIP Single Machine Installer Utilities 

These utils directory contains utilities which is helpful when any issue encountered.

## Reprocess a packet

This script is helps in reprocessing the packet which is stuck in the flow by again setting the retry count in the table as 0 and again sending it to packet uploader stage with new token.

* To reprocess stuck packets    
` ./reprocess.py <upd_times>`   
    reprocess script will pick all the stuck packets whic got updated in registration table after time upd_times.   
    ex: ./reprocess.py 2019-12-27 09:35:27.164

## Run service / Restart Service

This script will stop the existing running service if running and then start the service mentioned.

* To Start/Restart a service    
` ./run_service.py <mosip_service>`     
    mosip_service can be any of below service that can be used to start/restart a service.  
    ` registration-processor-packet-receiver-stage`     
    ` registration-processor-packet-uploader-stage`     
    ` registration-processor-packet-validator-stage`      
    ` registration-processor-quality-checker-stage`     
    ` registration-processor-osi-validator-stage`    
    ` registration-processor-registration-status-service`     
    ` registration-processor-common-camel-bridge`
