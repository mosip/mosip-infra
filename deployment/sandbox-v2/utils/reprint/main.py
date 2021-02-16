import argparse
import sys
import traceback

from paths import envPath, logPath, vidListPath, vidRequestId
from dotenv import load_dotenv
load_dotenv()

# OR, the same with increased verbosity
load_dotenv(verbose=True)

load_dotenv(dotenv_path=envPath)

from api import MosipSession
from db import DatabaseSession
from utils import initLogger, myPrint, writeJsonFile, getJsonFile
import config as conf


def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('action', help='get_vids|reprint|all')
    args = parser.parse_args()
    return args, parser


def main():
    args, parser = args_parse()

    initLogger(logPath)
    try:
        if args.action == 'get_vids' or args.action == 'all':
            myPrint("Action: get_vids", 1)
            vids = []
            vid_dicts = DatabaseSession(conf.db_host, conf.db_port, conf.db_user, conf.db_pass).getVids()
            for vid_dict in vid_dicts:
                vids.append(vid_dict['vid'])
            writeJsonFile(vidListPath, vids)

        if args.action == 'reprint' or args.action == 'all':
            myPrint("Action: reprint", 1)
            output = []
            vids = getJsonFile(vidListPath)
            ms = MosipSession(conf.server, conf.client_id, conf.secret_key, conf.app_id)
            for vid in vids:
                resp = ms.credentialRequest(vid)
                output.append(resp)
            writeJsonFile(vidRequestId, output)
            myPrint('Input VIDs: ' +  str(len(vids)), 12)
            myPrint('Output RequestIds: ' + str(len(output)), 12)


    except:
        formatted_lines = traceback.format_exc()
        myPrint(formatted_lines, 13)
        sys.exit(1)

    return sys.exit(0)


if __name__ == "__main__":
    main()
