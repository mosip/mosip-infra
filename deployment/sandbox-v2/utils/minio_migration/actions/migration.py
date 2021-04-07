import hashlib
import os
from multiprocessing import Pool

import uuid as uuid

from minioWrapper import MinioWrapper
import config as conf
from paths import packetListPath, statPath
from utils import getJsonFile, myPrint, chunkIt, writeFile, getLastPath


class Migration:
    def __init__(self):
        self.m = MinioWrapper()
        self.clean()
        return

    def run(self):
        self.m.createBucket(conf.new_bucket_name)
        packet_names = getJsonFile(packetListPath)
        myPrint("Total " + str(len(packet_names)) + " packets found", 12)
        if conf.records is not None:
            packet_names = packet_names[0:conf.records]
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

    def checkHash(self, packet_name):
        myPrint("Migrating " + packet_name, 3)
        bucketObjects = self.m.listObjects(packet_name, True)
        newBucketObjects = self.m.listObjects(conf.new_bucket_name, True, "/"+packet_name)
        for obj in bucketObjects:
            for new_obj in newBucketObjects:
                if getLastPath(obj) == getLastPath(new_obj):
                    o1 = self.m.getObject(packet_name, obj)
                    o2 = self.m.getObject(conf.new_bucket_name, new_obj)
                    h1 = getHash(o1)
                    myPrint("Hash of "+obj+": "+h1)
                    h2 = getHash(o2)
                    myPrint("Hash of " + new_obj + ": " + h2)
                    if h1 == h2:
                        myPrint("Hashes match")
                    else:
                        myPrint("Hashes not match")
                        raise RuntimeError("Hashes not match")


def getHash(p):
    return hashlib.sha256(p).hexdigest()


def runner(packet_names_chunk):
    uid = str(uuid.uuid4())
    file_path = os.path.join(statPath, uid + ".log")
    m = MinioWrapper()
    coui = 1
    for packet_name in packet_names_chunk:
        migrate(m, packet_name)
        writeFile(file_path, str(coui) + " out of " + str(len(packet_names_chunk)) + "\n")
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
