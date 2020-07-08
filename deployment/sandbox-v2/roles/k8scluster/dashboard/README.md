Source: https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml

Following has been added to the above:
* admin-user service account added for access to dashboard using token
* Nodeport added to dashboard service.  See: https://mosip.atlassian.net/browse/MOSIP-8035

TODO: Consider using dashboard helm chart
