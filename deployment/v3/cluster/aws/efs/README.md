# EFS Driver 

This is required for having a dynamic provisioned storage class with ReadWriteMany

Install with procedure mentioned here:
https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

To set reclaim policy of EFS driver to "retain" check the helm values  here:
https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/charts/aws-efs-csi-driver/values.yaml
