# To Mount NFS folder to regproc packet server and regproc group 1 stage:

* Update NFS server and path in dmz-landing-pv.yaml and dmz-pkt-pv.yaml.
* Run commands in sequential:
```
kubectl apply -f dmz-sc.yaml
kubectl apply -f dmz-pkt-pv.yaml
kubectl apply -f dmz-pkt-pvc.yaml
kubectl apply -f dmz-landing-pv.yaml
kubectl apply -f dmz-landing-pvc.yaml
```
* Edit persistent Volume claim name in regproc-group1 deployment as given in dmz-landing-pvc.yaml
* Edit persistent Volume claim name in regproc-pktserver deployment as given in dmz-pkt-pvc.yaml