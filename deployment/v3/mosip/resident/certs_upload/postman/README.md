# Resident Cert Upload (_Work-in-progress_)

The folder here contains Postman Collection to upload RESIDENT certs.

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
│                requests │                   8 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│            test-scripts │                   8 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│      prerequest-scripts │                   4 │                   0 │
├─────────────────────────┼─────────────────────┼─────────────────────┤
│              assertions │                   9 │                   0 │
├─────────────────────────┴─────────────────────┴─────────────────────┤
│ total run duration: 3.7s                                            │
├─────────────────────────────────────────────────────────────────────┤
│ total data received: 7.16KB (approx)                                │
├─────────────────────────────────────────────────────────────────────┤
│ average response time: 432ms [min: 112ms, max: 1461ms, s.d.: 413ms] │
└─────────────────────────────────────────────────────────────────────┘

```
