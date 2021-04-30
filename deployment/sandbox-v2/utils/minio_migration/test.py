import argparse
import sys
import traceback

from paths import envPath, logPath, bucketListPath, packetListPath, ignoredBucketListPath, hashCheckPacketsPacket, \
    migratedPackets
from dotenv import load_dotenv
load_dotenv()

# OR, the same with increased verbosity
load_dotenv(verbose=True)

load_dotenv(dotenv_path=envPath)
from minioWrapper import MinioWrapper
from actions.migration import Migration

from utils import initLogger, myPrint, getTimeInSec, timeDiff, getJsonFile
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
        if args.action == 'remove_bucket' or args.action == 'all':
            myPrint("Action: remove_bucket test", 1)
            m = MinioWrapper()
            myPrint(m.deleteBucket())
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action remove_bucket: " + prstr, 11)
        if args.action == 'check_hash' or args.action == 'all':
            myPrint("Action: check_hash test", 1)
            packet_names = getJsonFile(hashCheckPacketsPacket)
            for packet in packet_names:
                myPrint("Packet name: "+packet, 2)
                Migration().checkHash(packet)
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action check_hash: " + prstr, 11)
        if args.action == 'check_records' or args.action == 'all':
            myPrint("Action: check_records", 1)
            total_buckets = getJsonFile(bucketListPath)
            total_packets = getJsonFile(packetListPath)
            total_ignored = getJsonFile(ignoredBucketListPath)
            total_migrated = getJsonFile(migratedPackets)
            myPrint("total_buckets: "+str(len(total_buckets)))
            myPrint("total_packets: " + str(len(total_packets)))
            myPrint("total_ignored: " + str(len(total_ignored)))
            myPrint("total_migrated: " + str(len(total_migrated)))
            myPrint(list(set(total_packets) - set(total_migrated)))
            prev_time, prstr = timeDiff(prev_time)
            myPrint("Time taken by Action check_records: " + prstr, 11)
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
