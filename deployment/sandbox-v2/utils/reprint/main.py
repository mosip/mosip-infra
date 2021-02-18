import argparse
import hashlib
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
from utils import initLogger, myPrint, writeJsonFile, getJsonFile, ridToCenterTimestamp
import config as conf


def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('action', help='get_vids|fetch_info|reprint|all')
    args = parser.parse_args()
    return args, parser


def main():
    args, parser = args_parse()

    initLogger(logPath)
    db = DatabaseSession(conf.db_host, conf.db_port, conf.db_user, conf.db_pass)
    try:
        if args.action == 'get_vids' or args.action == 'all':
            myPrint("Action: get_vids", 1)
            vids = []
            vid_dicts = db.getVids()
            for vid_dict in vid_dicts:
                vids.append(vid_dict['vid'])
            writeJsonFile(vidListPath, vids)

        if args.action == 'fetch_info' or args.action == 'all':
            output = []
            myPrint("Action: get uin by vid", 1)
            ms = MosipSession(conf.server, conf.regproc_client_id, conf.regproc_secret_key, conf.regproc_app_id)
            vids = getJsonFile(vidListPath)
            for vid in vids:
                myPrint("Operating on VID "+vid)
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

        if args.action == 'reprint' or args.action == 'all':
            myPrint("Action: reprint", 1)
            output = []
            vids = getJsonFile(credentialPreparedDataPath)
            ms = MosipSession(conf.server, conf.ida_client_id, conf.ida_secret_key, conf.ida_app_id)
            for vidInfo in vids:
                resp = ms.credentialRequest(vidInfo)
                output.append(resp)
            writeJsonFile(vidRequestId, output)
            myPrint('Input VIDs: ' +  str(len(vids)), 12)
            myPrint('Output RequestIds: ' + str(len(output)), 12)

        db.closeAll()
    except:
        db.closeAll()
        formatted_lines = traceback.format_exc()
        myPrint(formatted_lines, 13)
        sys.exit(1)

    return sys.exit(0)


if __name__ == "__main__":
    main()
