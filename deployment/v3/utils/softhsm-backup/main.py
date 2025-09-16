import os
import subprocess
import boto3
import shutil
import logging
from datetime import datetime, timedelta
from kubernetes import client, config
from botocore.exceptions import ClientError
import pytz

# Configuration
S3_BUCKET = os.getenv("S3_BUCKET", "s3-bucket-name")
S3_BASE_FOLDER = os.getenv("S3_BASE_FOLDER", "softhsmbackup")
NAMESPACE = os.getenv("NAMESPACE", "softhsm")
TOKENS_PATH = os.getenv("POD_TOKENS_PATH", "/softhsm/tokens")
DAYS_TO_KEEP = int(os.getenv("S3_RETENTION_DAYS", 15))
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
AWS_REGION = os.getenv("AWS_REGION", "us-west-1")

# Load Kubernetes configuration locally
#config.load_kube_config()
# Use this when running inside a Kubernetes pod
config.load_incluster_config()

# Initialize S3 client
s3 = boto3.client('s3',
                  aws_access_key_id=AWS_ACCESS_KEY_ID,
                  aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
                  region_name=AWS_REGION)

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def upload_to_s3(local_folder, s3_path):
    """Uploads a local folder to an S3 bucket."""
    try:
        for root, dirs, files in os.walk(local_folder):
            for file in files:
                local_file_path = os.path.join(root, file)
                relative_path = os.path.relpath(local_file_path, local_folder)
                relative_path = os.path.normpath(relative_path)
                relative_path = relative_path.replace("\\", "/")
                s3_key = os.path.join(s3_path, relative_path)
                s3.upload_file(local_file_path, S3_BUCKET, s3_key)
                logging.info(f"Uploaded: {s3_key}")
    except ClientError as e:
        logging.error(f"Failed to upload to S3: {e}")
        raise

def delete_old_s3_folders(s3_folder, days=DAYS_TO_KEEP):
    utc = pytz.utc
    cutoff_date = datetime.now(utc) - timedelta(days=days)

    # List objects in the specified S3 folder
    paginator = s3.get_paginator('list_objects_v2')
    for page in paginator.paginate(Bucket=S3_BUCKET, Prefix=s3_folder + '/', Delimiter='/'):
        for common_prefix in page.get('CommonPrefixes', []):
            folder_name = common_prefix['Prefix'].rstrip('/').split('/')[-1]  # Get the folder name
            try:
                folder_date_str = folder_name.split('-')[-6:]  # Extract DD-MM-YY-HH-MM-UTC
                folder_date_str = '-'.join(folder_date_str[:-1])  # Remove the "UTC" part
                folder_date = datetime.strptime(folder_date_str, '%d-%m-%y-%H-%M').replace(tzinfo=utc)

                # Delete folder if older than the cutoff date
                if folder_date < cutoff_date:
                    logging.info(f"Deleting old folder: {folder_name}")
                    s3_objects = s3.list_objects_v2(Bucket=S3_BUCKET, Prefix=f"{s3_folder}/{folder_name}/")
                    if 'Contents' in s3_objects:
                        for obj in s3_objects['Contents']:
                            s3.delete_object(Bucket=S3_BUCKET, Key=obj['Key'])
                        logging.info(f"Deleted folder and its contents: {folder_name}")
            except Exception as e:
                logging.error(f"Error processing folder {folder_name}: {e}")


def process_pod(pod_name):
    """Processes a single pod to copy tokens and upload them to S3."""
    temp_folder = f"/tmp/{pod_name}_tokens/tokens"
    os.makedirs(temp_folder, exist_ok=True)

    try:
        logging.info(f"Copying tokens from pod: {pod_name}")
        # Copy the tokens folder from the pod to the local machine
        subprocess.run(["kubectl", "cp", f"{NAMESPACE}/{pod_name}:{TOKENS_PATH}", temp_folder], check=True)

        # Upload the tokens folder to S3
        current_date = datetime.utcnow().strftime('%d-%m-%y-%H-%M-UTC')
        s3_path = f"{S3_BASE_FOLDER}/{S3_BASE_FOLDER}-{current_date}/{pod_name}-tokens/tokens/"
        upload_to_s3(temp_folder, s3_path)

        logging.info(f"Uploaded tokens for {pod_name} to S3 path: {s3_path}")

    except (subprocess.CalledProcessError, ClientError, Exception) as e:
        logging.error(f"Error processing pod {pod_name}: {e}")

    finally:
        # Clean up the local temporary folder
        if os.path.exists(temp_folder):
            shutil.rmtree(temp_folder)
            logging.info(f"Cleaned up local temporary folder")

def main():
    try:
        # Get all pods in the softhsm namespace
        v1 = client.CoreV1Api()
        pods = v1.list_namespaced_pod(NAMESPACE)

        # Loop through each pod and copy the tokens folder
        for pod in pods.items:
            pod_name = pod.metadata.name
            logging.info(f"Processing pod: {pod_name} in namespace: {NAMESPACE}")
            process_pod(pod_name)

        # Delete folders older than the configured retention period
        delete_old_s3_folders(S3_BASE_FOLDER)

    except Exception as e:
        logging.error(f"Error in main process: {e}")

if __name__ == "__main__":
    main()

