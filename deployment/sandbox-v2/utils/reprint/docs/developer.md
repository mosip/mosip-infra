# Developer docs for migration script

## Get Vids
Fetch all the VIDs from database

_Command: python3 main.py get_vids_

Output: generatedData/vidList.json

## Get Additional info
Fetch additional info required like center_id, timestamp

_Command: python3 main.py fetch_info_

Input: generatedData/vidList.json

Output: generatedData/credentialPreparedData.json

### Re-print request
Execute the credential request for each VID

_Command: python3 main.py reprint_

Input: inputData/credentialPreparedData.json

Output: outputData/vidRequestIdMap.json