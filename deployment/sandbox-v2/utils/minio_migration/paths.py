import os

# Maven local repo
from pathlib import Path

home = str(Path.home())

# Env file path
envPath = os.path.abspath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), './', '.env')
)

rootPath = os.path.abspath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), './')
)

logPath = os.path.abspath(
    os.path.join(rootPath, 'out.log')
)

statPath = os.path.abspath(
    os.path.join(rootPath, 'stats')
)

generatedDataFolderPath = os.path.abspath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), './', 'generatedData')
)

# result paths
bucketListPath = os.path.join(generatedDataFolderPath, 'bucketList.json')
packetListPath = os.path.join(generatedDataFolderPath, 'packetList.json')
ignoredBucketListPath = os.path.join(generatedDataFolderPath, 'ignoredBucketList.json')
credentialPreparedDataPath = os.path.join(generatedDataFolderPath, 'credentialPreparedData.json')
runResult = os.path.join(generatedDataFolderPath, 'runResult.json')
vidRequestId = os.path.join(generatedDataFolderPath, 'vidRequestId.json')
hashCheckPacketsPacket = os.path.abspath(os.path.join(generatedDataFolderPath, 'checkHash.json'))
migratedPackets = os.path.abspath(os.path.join(generatedDataFolderPath, 'migratedPackets.json'))
