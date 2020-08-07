# Registration Processor Test Packet Uploader 

## Prerequisites

The scripts here require `python3` that must have got installed during the standard deployment setup.

## Packet creation

Parameters of packet are specified in `config.py`. For standard deployment you need to modify only `server` as given below. 

1. `server`:  This must point to your sandbox domain 
1. `user` and `password` must be available in Keycloak. The user must have all roles assigned. 
1. `prereg_id`: If specified regproc will connect to prepreg to fetch details of this id. By default this is null.
1.  Rest of the parameters must match your master data records.  

## Clearing the DB
This is optional.  To see your packet clearly, you may want to clear all records of previous packets in `mosip_regprc` tables:

```
$ ./cleardb.sh
```
Provide your postgres password.

## Upload registration packet

```
$ ./test_regproc.py
```

## Verify
Verify the transactions as below:

```
$ ./checkdb.sh

```
Provide postgres password.  Note that it may take several seconds for packet to go through all the stages.  You must see a `SUCCESS` for all stages. 
    
