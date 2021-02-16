# Developer docs for migration script

## Get Vids
Records in input data gets converted to ready to use format. It contains three stages:
* Parsing
* Mapping
* Master data getter

_Command: python3 main.py get_vids_

Output: outputData/vidList.json

### Re-print request
Parse and format records from input data

_Command: python3 main.py reprint_

Input: inputData/vidList.json

Output: outputData/vidRequestIdMap.json