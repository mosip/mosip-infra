import os

minio_endpoint = os.getenv("mm_minio_endpoint")
new_bucket_name = os.getenv("mm_new_bucket_name")
access_key = os.getenv("mm_access_key")
secret_key = os.getenv("mm_secret_key")
region = os.getenv("mm_region") if os.getenv("mm_region") is not None and len(os.getenv("mm_region")) > 0 else None

# JSON print related
json_sort_keys = True
json_indent = 4
