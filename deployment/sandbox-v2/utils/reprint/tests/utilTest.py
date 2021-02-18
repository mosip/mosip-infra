import unittest
from paths import logPath
from utils import ridToCenterTimestamp, initLogger, myPrint

initLogger(logPath)


class MyTestCase(unittest.TestCase):

    def test_util(self):
        print("OKay")
        myPrint(ridToCenterTimestamp("10002100040000220201011155747"))
