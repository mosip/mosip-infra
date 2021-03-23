from minioWrapper import MinioWrapper
from paths import bucketListPath
from utils import writeJsonFile, myPrint


class GetBuckets:
    def __init__(self):
        self.m = MinioWrapper()
        return

    def run(self):
        bucket_names = self.m.listBucketNames()
        writeJsonFile(bucketListPath, bucket_names)
        myPrint("Total " + str(len(bucket_names)) + " buckets found")