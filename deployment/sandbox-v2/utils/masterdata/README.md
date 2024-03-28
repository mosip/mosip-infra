# Masterdata Upload Utility

## Overview
Refer [Masterdata Guide](https://docs.mosip.io/1.2.0/deployment/masterdata-guide).

## Prequisites
1. `python3.9` virtual env
1. Switch to virtual env
TODO: Check if below are needed
2. Install dev tools:
	```
	sudo apt install python3-dev libpq-dev
	```
3. Install additional modules:
	```
	pip install -r requirements.txt
	```
4. (Optional) Install [XLS diff utiliy](https://github.com/na-ka-na/ExcelCompare).

## Run
1. Checkout `mosip-data` repo at location of your choice:
    ```
    git clone https://github.com/mosip/mosip-data -b develop 
    ```
1. 
    ```sh
    ./upload_md.sh <path of mosip-data repo>/mosip_master/xlsx
    ```
    The shell script runs `lib/upload_masterdata.py` script.

1. To populate data only in specific tables comment out unwanted tables in `lib/table_order` with a `#` at the start of each line. 

# Docker
See `entrypoint.sh` to see the steps performed to upload default masterdata. Also see [Dockerfile](./Dockerfile) and [sample docker run script](docker-run.sh).
