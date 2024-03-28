# Reproces packet

## Context
Registration Processor provides Reprocessor stage that processes failed packets at a schedule specified by a cron job. However, if you need to process packets manually then you may use the script provided here.

## Prerequisites
Install required packages using
```
$ ./preinstall.sh
```
## Config
1. Set the `server` url in `config.py`
1. If the url has HTTPS and server SSL certificate is self-signed then set `ssl_verify=False`.
1. Set all environment variables.
1. Set the `delay` between processing two RIDs.

## Run
The script takes Registration Ids (RIDs) as input. Provide RID directly as argument or via a file. Example:
```
$ ./reprocess.py --rid 1000210074000052021012.0.1401

OR

$ ./reprocess.py --file rids.txt

where rids.txt looks like:
1000210074000052021012.0.1401
10001100130000120210114122006
...
...

OR

$ ./reprocess.py --db

Here RIDs will be fetched from db based on the query given in config.py.
```


