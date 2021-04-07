from datetime import timedelta

import certifi
import urllib3
from minio import Minio, S3Error
from minio.commonconfig import ComposeSource, CopySource
from minio.deleteobjects import DeleteObject
from minio.error import InvalidResponseError, MinioException
from minio.datatypes import Bucket, Object
import config as conf
from utils import myPrint


class MinioWrapper:
    def __init__(self):
        myPrint(conf.minio_endpoint)
        myPrint(conf.access_key)
        myPrint(conf.region)
        self.client = self.createConnection()

    def createConnection(self):
        timeout = timedelta(minutes=15).seconds
        if conf.region is not None:
            return Minio(
                conf.minio_endpoint,
                access_key=conf.access_key,
                secret_key=conf.secret_key,
                region=conf.region,
            )
        else:
            return Minio(
                conf.minio_endpoint,
                access_key=conf.access_key,
                secret_key=conf.secret_key,
                secure=False,
                http_client=urllib3.PoolManager(
                    timeout=urllib3.util.Timeout(connect=timeout, read=timeout),
                    maxsize=50,
                    cert_reqs='CERT_REQUIRED',
                    ca_certs=certifi.where(),
                    retries=urllib3.Retry(
                        total=2,
                        backoff_factor=0.2,
                        status_forcelist=[500, 502, 503, 504]
                    )
                )
            )

    def listBucketNames(self):
        try:
            bucket_names = []
            buckets: [Bucket] = self.client.list_buckets()
            for bucket in buckets:
                bucket_names.append(bucket.name)
            return bucket_names
        except InvalidResponseError as e:
            raise RuntimeError(e)

    def createBucket(self, bucket_name):
        if not self.client.bucket_exists(bucket_name):
            if conf.region is not None:
                self.client.make_bucket(bucket_name)
            else:
                self.client.make_bucket(bucket_name)
        else:
            myPrint("Bucket with name "+bucket_name+" already exists", 11)

    def bucketExists(self, bucket_name):
        try:
            if self.client.bucket_exists(bucket_name):
                return True
            else:
                return False
        except InvalidResponseError as e:
            myPrint(e)
            return False

    def listObjects(self, bucket_name, recursive=False, prefix=None):
        object_names = []
        try:
            if prefix is not None:
                objects = self.client.list_objects(bucket_name, prefix=prefix, recursive=recursive)
            else:
                objects = self.client.list_objects(bucket_name, recursive=recursive)
            for obj in objects:
                object_names.append(obj.object_name)
            return object_names
        except InvalidResponseError as e:
            raise RuntimeError(e)

    def getObject(self, bucket_name, object_name):
        data = None
        response = None
        try:
            response = self.client.get_object(bucket_name, object_name)
            data = response.read()
        finally:
            response.close()
            response.release_conn()
        return data

    def composeSources(self, source_bucket_name, objects):
        sources = []
        for obj in objects:
            sources.append(
                ComposeSource(source_bucket_name, obj)
            )
        return sources

    def composeObject(self, bucket_name, object_name, sources):
        result = self.client.compose_object(bucket_name, object_name, sources)
        return result.object_name, result.version_id

    def copyObject(self, bucket_name, object_name, source_bucket_name, source_object):
        result = self.client.copy_object(
            bucket_name,
            object_name,
            CopySource(source_bucket_name, source_object)
        )
        return result.object_name, result.version_id

    def putObject(self, bucket_name, object_name):
        return

    def deleteBucket(self):
        bucket_name = "my-test-bucket"
        myPrint("Fetching objects level 1 list")
        myPrint("Total objects level 1 " + str(len(self.listObjects(bucket_name, False))))
        myPrint("Fetching object recursive list")
        object_names = self.listObjects(bucket_name, True)
        removed_objects = []
        myPrint("Total objects " + str(len(object_names)))
        for obj_name in object_names:
            removed_objects.append(DeleteObject(obj_name))
        errors = self.client.remove_objects(bucket_name, removed_objects)
        for error in errors:
            myPrint(error, 11)
        self.client.remove_bucket(bucket_name)
