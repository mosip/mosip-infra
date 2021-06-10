# Cluster monitoring

## Prometheus
* Assuming you are using Rancher for cluster management, enable Prometheus via Rancher Apps.
* All MOSIP modules have been configured to let Prometheus scrape metrics.

## Grafana
To load a new dashboards to Grafana, sign in with user and password returned by `get_pwd.sh` script.

To see JVM stats you may import chart number `14430` in Grafana dashboard.
