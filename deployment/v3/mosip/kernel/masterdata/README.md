# Masterdata Upload Utility

## Introduction
Masterdata is specified in xlsx files available in `xlsx` folder.  Update the xlsx as per the [masterdata guide](../../../../docs/master_data_tables.xlsx) and run the upload utility. Note that you must run this utility only once to seed the DB data first time.  Subsequently, for any updates use Admin UI or Masterdata APIs. 

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
	pip3 install -r requirements.txt
	```
4. (Optional) Install [XLS diff utiliy](https://github.com/na-ka-na/ExcelCompare).

## Run
```sh
./upload_md.sh
```
The utility will run with default parameters. If your setup is different, update `upload_md.sh`.  You can find the parameters expected by utility with this command:
```
python3 lib/upload_masterdata.py --help
```
