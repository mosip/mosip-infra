# Dashboards Guide

This document contains miscellaneous tips to use various dashboards that are made available as part of the default sandbox installation.

## Kibana
### Set Kibana to view error logs
1. Open `https://<sandbox domain name>/kibana`
1. Click on 'Explore on my own' if it pops up a welcome message.
1. Click on top left menu and select Kibana->Discover.
1. If it asks to add an index pattern add as below.
1. Enter `filebeat-*` pattern inside 'Define Index Pattern' box. Go to next step.
1. Select `@timestamp` in 'Configure settings'.
1. Go to main menu --> discover.  You should see the dashboard screen with `filebeat-*` shown as index pattern.
1. Enter the desired fields and add them using the search box on the left 'Search field names'. Some logs must exist for the fields to appear in search.
1. You may save this dashboard by clicking on 'Save' tab.
1. If the dashboard is already saved, you may open it using the 'Open' tab.


## Kubernetes dashboard
* Dashboard links:
    * MZ: `https://<sandbox domain name>/dashboard-mz`
    * DMZ: `https://<sandbox domain name>/dashboard-dmz`
* The tokens for above dashboards are available on the console machine at `/home/mosipuser/mosip-infra/deployment/sandbox-v2/tmp`

## Grafana
* Link:
   * `https://<sandbox domain name>/grafana`

* Recommended charts:
  * 11074
