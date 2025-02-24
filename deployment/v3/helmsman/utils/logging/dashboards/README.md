# Logging Dashboards
Following is a description of dashboards available in this folder.
- [01-logstash.ndjson](./01-logstash.ndjson) contains the `logstash` _Index Pattern_ required by the rest of the dashboards.
- [02-error-only-logs.ndjson](./02-error-only-logs.ndjson) contains a _Search_ dashboard which shows only the error logs of the services, called `MOSIP Error Logs` dashboard.
- [03-service-logs.ndjson](./03-service-logs.ndjson) contains a _Search_ dashboard which show all logs of a particular service, called `MOSIP Service Logs` dashboard.
- [04-insight.ndjson](./04-insight.ndjson) contains dashboards which show insights into MOSIP processes, like the number of UINs generated (total and per hr), the number of Biometric deduplications processed, number of packets uploaded etc, called `MOSIP Insight` dashboard.
- [05-response-time.ndjson](./05-response-time.ndjson) contains dashboards which show how quickly different MOSIP Services are responding to different APIs, over time, called `Response Time` dashboard.
