from minio import Minio, S3Error
from minio.commonconfig import ComposeSource, CopySource
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
                secure=False
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

    def listObjects(self, bucket_name, recursive=False):
        object_names = []
        try:
            for obj in self.client.list_objects(bucket_name, recursive=recursive):
                object_names.append(obj.object_name)
            return object_names
        except InvalidResponseError as e:
            raise RuntimeError(e)

    def getObject(self, bucket_name, object_name):
        data = None
        response = None
        try:
            response = self.client.get_object(bucket_name, object_name)
            myPrint(response.read())
            data = response.status
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
