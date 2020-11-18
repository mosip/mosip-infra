A sample dashboard has been created in Kibana, exported as json and then imported using Ansible.  To export a dashboard, use REST API as below:

```
curl -X GET http://mzworker0.sb:30080/kibana/api/kibana/dashboards/export?dashboard=e93d4a00-0925-11eb-b613-6b9eee02d203  > db.json
```

The dahsboard id may be found in the Kibana URL (on the browser) when you open the dashboard.

There are some saved filter queries as well in file `queries.ndjson`.  This file is generated using `export.sh`.
