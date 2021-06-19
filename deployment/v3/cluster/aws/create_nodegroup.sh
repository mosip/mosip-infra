eksctl create nodegroup \
  --cluster v3box1 \
  --version 1.19.8 \
  --name t3a-2xlarge-64gb-disk \
  --node-type t3a.2xlarge \
  --nodes 4 \
  --nodes-min 4 \
  --nodes-max 4 \
  --node-ami auto
