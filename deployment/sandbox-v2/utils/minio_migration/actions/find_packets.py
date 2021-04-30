from paths import bucketListPath, packetListPath, ignoredBucketListPath
from utils import getJsonFile, regMatch, writeJsonFile, myPrint


class FindPackets:
    def __init__(self):
        return

    def run(self):
        packets = []
        ignored = []
        bucket_names = getJsonFile(bucketListPath)
        for bucket_name in bucket_names:
            if regMatch(r"^[1-9]\d{28}$", bucket_name):
                packets.append(bucket_name)
            else:
                ignored.append(bucket_name)
        writeJsonFile(packetListPath, packets)
        writeJsonFile(ignoredBucketListPath, ignored)
        myPrint("Total " + str(len(packets)) + " packets found")
        myPrint("Total " + str(len(ignored)) + " ignored buckets found")