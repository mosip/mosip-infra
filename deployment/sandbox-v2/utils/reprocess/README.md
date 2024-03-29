# Reproces packet

## Context
Registration Processor provides Reprocessor stage that processes failed packets automatically at a schedule specified by a cron job in configuration. However, if you need to process packets manually then you may use the script provided here.

## Prerequisites
Install required packages using
```
$ ./preinstall.sh
```
## Config
1. Set the `server` url in `config.py`
1. If the URL has HTTPS and server SSL certificate is self-signed then set `ssl_verify=False`.
1. Set all environment variables given in `config.py`.
1. Set the `delay` between processing two RIDs (default is 1 second).

## Run
The script takes Registrations as input. Provide RID, process and workflow instance id directly as argument or via a file. Example:
```
$ ./reprocess.py --registration "'10001101040000520220809113748', 'NEW', 'e6e944b1-5c4b-42aa-b749-b39428cb7512'"

OR

$ ./reprocess.py --file registrations.txt

where registrations.txt looks like ('registration id', 'process', 'workflow instance id'):
'10001101040000520220809113748', 'NEW', 'e6e944b1-5c4b-42aa-b749-b39428cb7512'
'10001101040000520220809113730', 'UPDATE', 'e6e944b1-5c4b-42aa-b749-b39428cb7333'
'10001101040000520220809113732', 'NEW', 'e6e944b1-5c4b-42aa-b749-b39428cb3838'
'10001101040000520220809113722', 'NEW', 'e6e944b1-5c4b-42aa-b749-b39428cb3iii'
'10001101040000520220809113721', 'NEW', 'e6e944b1-5c4b-42aa-b749-b39428cb8888'
...
...

OR

$ ./reprocess.py --db

Here RIDs will be fetched from db based on the query given in config.py.
```


