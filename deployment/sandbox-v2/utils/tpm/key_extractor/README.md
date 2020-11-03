# TPM Key Extractor

Utility to get TPM public keys along with machine name.

## Prerequisites

Requires Java 11.

## Build
```
$ mvn clean install
```

## Run
```
$ java -jar tpmutility-0.0.1.jar
```
(Use `jar-with-dependencies` to run under `target` folder)

## Sample output

```
{"machineName" : "S540-14IWL", "publicKey" : "AAEACwACAHIAIINxl2dEhLP4GpDMjUal1yT9UtduBlILZPKh2hszFGmqABAAFwALCAAAAQABAQDiSa_AdVmDrj-ypFywexe_eSaSsrIoO5Ns0jp7niMu4hiFIwsFT7yWx2aQUQcdX5OjyXjv_XJctGxFcphLXke5fwAoW6BsbeM__1Mlhq9YvdMKlwMjhKcd-7MHHAXPUKGVmMjIJe6kWwUWh7FaZyu5hDymM5MJyYZRxz5fRos_N9ykiBxjWKZK06ZpIYI6Tj9rUNZ6HAdbJH2RmBHuO0knpbXdB-lnnVhvArAt3KWoyH3YzodHeOLJRe_Y8a-p8zRZb5h1tqlcLgshpNAqb-WJgyq2xDb0RJwzuyjjHPmJrDqlBMXHestz-ADRwXQL44iVb84LcuMbQTQ1hGcawtBj", "signingPublicKey": "AAEABAAEAHIAAAAQABQACwgAAAEAAQEAw6CuS_sekZ02Z9_N3zz1fK_V3wm01PBcFM0nURerczjO2wqIxfmXpQQql3_S819nj_MwtkZ8K2ja0MRUJzJrmmbgBreFIGTa7Zhl9uAdzKghAA5hEaXV1YcxIl8m72vZpVX_dgqYzU8dccfRChsA-FxkVe5DCr_aXjVOUHjeXZRhQ1k-d7LzpBPVz-S69rx6W3bbxaZfV25HM93Hfm5P4aarYy0Wt0fJvv-Lmbyt0SIZFOQkYS8coW0-u8OiXm3Jur2Q8pu16q4F-Qpxqym-ACBFIsbkSCngQ_y4zGniK7WnS-dCSVhC-x1NscCq3PyXhoJOjSOdNqUkDX606Ic3SQ", "keyIndex": "BD:11:54:33:44:F9:5A:0B:B5:A6:B3:C1:F7:A8:28:47:0E:AA:20:21:01:16:37:89:D1:9C:8D:EC:96:5D:F5:A6", "signingKeyIndex": "41:EB:7E:7F:4F:A9:24:55:4C:5F:AB:3A:94:81:CF:75:C2:0B:92:DF:9B:89:47:D1:AD:B0:84:7A:F7:65:6A:88"}
```

## Machine master table

The `publicKey`, `signingPublicKey`, `keyIndex` and `signingKeyIndex` - all of them to be populated in the `machine_master*` table of `mosip_master` DB.
