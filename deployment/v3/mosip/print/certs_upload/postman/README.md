# Print partner Cert Upload (_Work-in-progress_)

The folder here contains Postman Collection to upload Print partner certs.

## Prerequisites
Install Postman (browser or command line).  The command line version is called `newman`.

## Run
* Inspect `env.json` for any changes in default params.
* Run on command line
```sh
newman run collection.json -e env.json  --env-var 'url=https://xxx.yyy.zzz' --env-var 'admin-client-secret=xxxxxxxxxxxx'
```

output:

```

┌─────────────────────────┬─────────────────────┬─────────────────────┐
│                         │            executed │              failed │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│              iterations │                   1 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│                requests │                   3 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│            test-scripts │                   3 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│      prerequest-scripts │                   3 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│              assertions │                   3 │                   0 │
├─────────────────────────┴─────────────────────┴─────────────────────┤
│ total run duration: 2s                                              │
├─────────────────────────────────────────────────────────────────────┤
│ total data received: 1.88KB (approx)                                │
├─────────────────────────────────────────────────────────────────────┤
│ average response time: 640ms [min: 245ms, max: 1058ms, s.d.: 332ms] │
└─────────────────────────────────────────────────────────────────────┘

```
