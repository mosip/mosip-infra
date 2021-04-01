import os
from multiprocessing import Pool

import uuid as uuid

from minioWrapper import MinioWrapper
import config as conf
from paths import packetListPath, statPath
from utils import getJsonFile, myPrint, chunkIt, appendFile


class Migration:
    def __init__(self):
        self.m = MinioWrapper()
        self.clean()
        return

    def run(self):
        self.m.createBucket(conf.new_bucket_name)
        packet_names = getJsonFile(packetListPath)
        myPrint("Total " + str(len(packet_names)) + " packets found", 12)
        packet_names_chunks = chunkIt(packet_names, conf.threads)
        i = 0
        for packet_names_chunk in packet_names_chunks:
            myPrint("Chunk " + str(i + 1) + ": total packet to be migrated are " + str(len(packet_names_chunk)))
        pool = Pool(conf.threads)
        pool.map(runner, packet_names_chunks)

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

    def clean(self):
        myPrint("Cleaning stat folder ", 3)
        for item in os.listdir(statPath):
            if item.endswith(".log"):
                os.remove(os.path.join(statPath, item))


def runner(packet_names_chunk):
    uid = str(uuid.uuid4())
    file_path = os.path.join(statPath, uid + ".log")
    m = MinioWrapper()
    coui = 1
    for packet_name in packet_names_chunk:
        migrate(m, packet_name)
        appendFile(file_path, str(coui) + " out of " + str(len(packet_names_chunk)) + "\n")
        coui = coui + 1


def migrate(minio_client, packet_name):
    myPrint("Migrating " + packet_name, 3)
    objects = minio_client.listObjects(packet_name, recursive=True)
    for obj in objects:
        new_obj = packet_name + "/" + obj
        myPrint("Copying from " + packet_name + " -> " + obj)
        myPrint("Copying to " + conf.new_bucket_name + " -> " + new_obj)
        minio_client.copyObject(
            conf.new_bucket_name,
            new_obj,
            packet_name,
            obj
        )
