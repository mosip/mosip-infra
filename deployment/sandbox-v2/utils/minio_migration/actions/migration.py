from minioWrapper import MinioWrapper
import config as conf
from paths import packetListPath
from utils import getJsonFile, myPrint


class Migration:
    def __init__(self):
        self.m = MinioWrapper()
        return

    def run(self):
        self.m.createBucket(conf.new_bucket_name)
        packet_names = getJsonFile(packetListPath)
        myPrint("Total " + str(len(packet_names)) + " packets found", 12)
        for packet_name in packet_names:
            self.migrate(packet_name)

    def migrate(self, packet_name):
        myPrint("Migrating " + packet_name, 3)
        objects = self.m.listObjects(packet_name, recursive=True)
        for obj in objects:
            new_obj = packet_name + "/" + obj
            myPrint("Copying from " + packet_name + " -> " + obj)
            myPrint("Copying to " + conf.new_bucket_name + " -> " + new_obj)
            self.m.copyObject(
                conf.new_bucket_name,
                new_obj,
                packet_name,
                obj
            )


