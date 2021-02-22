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

generatedDataFolderPath = os.path.abspath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), './', 'generatedData')
)

# result paths
vidListPath = os.path.join(generatedDataFolderPath, 'vidList.json')
credentialPreparedDataPath = os.path.join(generatedDataFolderPath, 'credentialPreparedData.json')
runResult = os.path.join(generatedDataFolderPath, 'runResult.json')
vidRequestId = os.path.join(generatedDataFolderPath, 'vidRequestId.json')