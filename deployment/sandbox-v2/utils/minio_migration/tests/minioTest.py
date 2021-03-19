import unittest
from paths import envPath, logPath
from dotenv import load_dotenv
load_dotenv()

# OR, the same with increased verbosity
load_dotenv(verbose=True)

load_dotenv(dotenv_path=envPath)

from minioWrapper import MinioWrapper
from utils import ridToCenterTimestamp, initLogger, myPrint
initLogger(logPath)


class MyTestCase(unittest.TestCase):

    def test_listBuckets(self):
        print("OKay")
        m = MinioWrapper()
        myPrint(m.listBuckets())

    def test_bucketExists(self):
        m = MinioWrapper()
        myPrint(m.bucketExists("10001100010002420210223073024"))

    def test_getObject(self):
        m = MinioWrapper()
        objects = [
            'RESIDENT/RES_UPDATE/10001100010002420210223073024_evidence',
            'RESIDENT/RES_UPDATE/10001100010002420210223073024_id',
            'RESIDENT/RES_UPDATE/10001100010002420210223073024_optional'
        ]
        myPrint(m.bucketExists("10001100010002420210223073024"))
        myPrint(m.listObjects("10001100010002420210223073024", recursive=True))
        myPrint(m.listObjects("10001100010002420210223073024", recursive=False))
        myPrint(
            m.copyObject(
                "my-test-bucket",
                'RESIDENT/RES_PDATE/10001100010002420210223073024_evidence',
                "10001100010002420210223073024",
                "RESIDENT/RES_UPDATE/10001100010002420210223073024_evidence"
            )
        )

    def test_deleteBucket(self):
        m = MinioWrapper()
        m.deleteBucket()