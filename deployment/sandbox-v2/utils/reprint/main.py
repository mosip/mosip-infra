import argparse
import hashlib
import json
import sys
import traceback

from paths import envPath, logPath, vidListPath, vidRequestId, credentialPreparedDataPath
from dotenv import load_dotenv
load_dotenv()

# OR, the same with increased verbosity
load_dotenv(verbose=True)

load_dotenv(dotenv_path=envPath)

from api import MosipSession
from db import DatabaseSession
from utils import initLogger, myPrint, writeJsonFile, getJsonFile, ridToCenterTimestamp, getTimeInSec, timeDiff
import config as conf


def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('action', help='get_vids|fetch_info|reprint|all')
    args = parser.parse_args()
    return args, parser


def main():
    args, parser = args_parse()
    initLogger(logPath)
    start_time = getTimeInSec()
    db = DatabaseSession(conf.db_host, conf.db_port, conf.db_user, conf.db_pass)
    try:
        prev_time = start_time
        if args.action == 'get_vids' or args.action == 'all':
            myPrint("Action: get_vids", 1)
            vids = []
            vid_dicts = db.getVids()
            for vid_dict in vid_dicts:
                vids.append(vid_dict['vid'])
            writeJsonFile(vidListPath, vids)
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action get_vids: " + prstr, 11)
        if args.action == 'fetch_info' or args.action == 'all':
            output = []
            myPrint("Action: fetch_info", 1)
            ms = MosipSession(conf.server, conf.regproc_client_id, conf.regproc_secret_key, conf.regproc_app_id)
            vids = getJsonFile(vidListPath)
            for vid in vids:
                myPrint("Operating on VID "+vid, 3)
                res = ms.getUin(vid)
                uin = res['identity']['UIN']
                if conf.debug:
                    myPrint("UIN: "+uin)

                modulo = int(uin) % conf.idrepo_modulo
                myPrint("Modulo: "+str(modulo))
                salt_row = db.getHash(modulo)
                if salt_row is not None:
                    salt = salt_row['salt']
                    if conf.debug:
                        myPrint("Salt: "+salt)
                    uin_hash = hashlib.sha256(bytes(uin+salt, 'utf-8')).hexdigest()
                    mod_uin_hash = str(modulo)+"_"+uin_hash.upper()
                    rid_row = db.getRid(mod_uin_hash)
                    if rid_row is not None:
                        rid = rid_row['rid']
                        myPrint("RID found")
                        if conf.debug:
                            myPrint("RID: " + rid)
                        center_id, timestamp = ridToCenterTimestamp(rid)
                        output.append({
                            'vid': vid,
                            'uin': uin,
                            'mod_uin_hash': mod_uin_hash,
                            'salt': salt,
                            'rid': rid,
                            'center_id': center_id,
                            'timestamp': timestamp
                        })
                    else:
                        raise RuntimeError("RID not found for for mod_uin_hash: "+mod_uin_hash)
                else:
                    raise RuntimeError("salt not found for for modulo: " + str(modulo))
            writeJsonFile(credentialPreparedDataPath, output)
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action fetch_info: " + prstr, 11)

        if args.action == 'reprint' or args.action == 'all':
            myPrint("Action: reprint", 1)
            output = []
            vids = getJsonFile(credentialPreparedDataPath)
            ms = MosipSession(conf.server, conf.ida_client_id, conf.ida_secret_key, conf.ida_app_id)
            for vidInfo in vids:
                myPrint("VID: "+vidInfo['vid'], 3)
                data = {
                    "id": vidInfo['vid'],
                    "credentialType": conf.credential_type,
                    "issuer": conf.partner_id,
                    "recepiant": "",
                    "user": "re_print_script",
                    "encrypt": False,
                    "encryptionKey": "",
                    "sharableAttributes": [],
                    "additionalData": {
                        'centerId': vidInfo['center_id'],
                        'creationDate': vidInfo['timestamp'],
                        'registrationId': vidInfo['rid']
                    }
                }
                json_data = json.dumps(data, separators=(',', ':'))
                myPrint(json_data)
                if db.checkRequestInCredentialTransaction(json_data) is None:
                    resp = ms.credentialRequest(data)
                    output.append(resp)
                else:
                    myPrint("Skipping credential request", 11)
            writeJsonFile(vidRequestId, output)
            myPrint('Input VIDs: ' +  str(len(vids)), 12)
            myPrint('Output RequestIds: ' + str(len(output)), 12)
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action reprint: " + prstr, 11)
        db.closeAll()
    except:
        db.closeAll()
        prev_time, prstr = timeDiff(start_time)
        myPrint("Total time taken by the script: " + prstr, 11)
        formatted_lines = traceback.format_exc()
        myPrint(formatted_lines, 13)
        sys.exit(1)
    prev_time, prstr = timeDiff(start_time)
    myPrint("Total time taken by the script: " + prstr, 11)
    return sys.exit(0)


if __name__ == "__main__":
    main()
