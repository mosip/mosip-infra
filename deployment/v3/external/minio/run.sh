kubectl minio tenant create minio-tenant-1 \
    --servers 1                              \
    --volumes 4                              \
    --capacity 8Gi                           \
    --namespace minio-tenant-1               \
    --storage-class gp2
