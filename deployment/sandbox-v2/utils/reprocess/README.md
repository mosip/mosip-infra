# Reproces packet

## Context
Registration Processor provides Reprocessor stage that processes failed packets at a schedule specified by a cron job. However, if you need to process packets manually then you may use the script provided here.

## Prequisites
Install required packets using
```
$ ./preinstall.sh
```

## Run
The script takes Registration Ids (RIDs) as input. Provide RID directly as argument or via a file. Example:
```
$ ./reprocess.py --rid 10002100740000520210122091401

OR

$ ./reprocess.py --file rids.txt

where rids.txt looks like:
10002100740000520210122091401
10001100130000120210114122006
...
...
```


