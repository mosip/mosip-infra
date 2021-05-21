##Installation of batch-processing reporting-framework using elk stack.

#Install postgres:
#Configure persistence if needed.

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgres bitnami/postgresql

#Install elasticsearch
--to-do--

#Install kibana
--to-do--

#Install logstash with modified values.yaml for creating pipelines at the time of installation.
helm install logstash elastic/logstash -f logstash_pipeline_sample.yaml

