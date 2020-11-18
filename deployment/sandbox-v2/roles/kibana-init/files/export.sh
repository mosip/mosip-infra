#!/bin/sh
# Export saved filter queries
curl -X POST http://mzworker0.sb:30080/kibana/api/saved_objects/_export -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '
{
  "type": "query"
}' > queries.ndjson
