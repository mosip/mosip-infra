import argparse
import sys
import traceback

from paths import envPath, logPath, bucketListPath, packetListPath, ignoredBucketListPath, migratedPackets
from dotenv import load_dotenv
load_dotenv()

# OR, the same with increased verbosity
load_dotenv(verbose=True)

load_dotenv(dotenv_path=envPath)

from actions.find_packets import FindPackets
from actions.get_buckets import GetBuckets
from actions.migration import Migration
from minioWrapper import MinioWrapper

from utils import initLogger, myPrint, getTimeInSec, timeDiff, writeJsonFile
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
        if args.action == 'get_buckets' or args.action == 'all':
            myPrint("Action: get_buckets", 1)
            GetBuckets().run()
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action get_buckets: " + prstr, 11)
        if args.action == 'find_packets' or args.action == 'all':
            myPrint("Action: find_packets", 1)
            FindPackets().run()
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action find_packets: " + prstr, 11)
        if args.action == 'migrate' or args.action == 'all':
            myPrint("Action: migrate", 1)
            Migration().run()
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action migrate: " + prstr, 11)
        if args.action == 'get_records' or args.action == 'all':
            myPrint("Action: get_records", 1)
            m = MinioWrapper()
            objs = m.listObjects(conf.new_bucket_name, False)
            new_objs = []
            for ob in objs:
                new_objs.append(ob.replace("/", ""))
            writeJsonFile(migratedPackets, new_objs)
            myPrint("Total objects level 1 " + str(len(new_objs)))
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action get_records: " + prstr, 11)
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
