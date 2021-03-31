import argparse
import sys
import traceback

from paths import envPath, logPath, bucketListPath, packetListPath, ignoredBucketListPath
from dotenv import load_dotenv
load_dotenv()

# OR, the same with increased verbosity
load_dotenv(verbose=True)

load_dotenv(dotenv_path=envPath)
from minioWrapper import MinioWrapper
from utils import initLogger, myPrint, getTimeInSec, timeDiff
import config as conf


def args_parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('action', help='get_buckets|find_packets|migrate|all')
    args = parser.parse_args()
    return args, parser


def main():
    args, parser = args_parse()
    initLogger(logPath)
    start_time = getTimeInSec()
    myPrint(conf.minio_endpoint)
    try:
        prev_time = start_time
        if args.action == 'check_conn' or args.action == 'all':
            myPrint("Action: check minio connection", 1)
            m = MinioWrapper()
            myPrint(m.bucketExists("my-test-bucket"))
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action check_conn: " + prstr, 11)
    except:
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
