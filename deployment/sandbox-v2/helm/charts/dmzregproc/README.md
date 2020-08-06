The helm chart here contains Reg Processor services that need to run on a separate DMZ cluster. 

Few points to note:

* `component: server-hazelcast-server` is important to define as it is referenced in hazelcast xmls:
```
 <properties>
     <property name="service-dns">service-hazelcast-server.default.svc.cluster.local</property>
 </properties>
```
* Ingress for pktserver is different as rewrite rule is different.  See pktserver-ingress.yaml

*   
