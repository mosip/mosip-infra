# IDA cert upload 
The folder here contains Postman Collection to upload IDA certs.

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

┌─────────────────────────┬────────────────────┬────────────────────┐
│                         │           executed │             failed │
├─────────────────────────┼────────────────────┼────────────────────┤
│              iterations │                  1 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│                requests │                 10 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│            test-scripts │                 10 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│      prerequest-scripts │                  4 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│              assertions │                 11 │                  0 │
├─────────────────────────┴────────────────────┴────────────────────┤
│ total run duration: 8.3s                                          │
├───────────────────────────────────────────────────────────────────┤
│ total data received: 8.87KB (approx)                              │
├───────────────────────────────────────────────────────────────────┤
│ average response time: 806ms [min: 80ms, max: 5.6s, s.d.: 1637ms] │
└───────────────────────────────────────────────────────────────────┘

```
