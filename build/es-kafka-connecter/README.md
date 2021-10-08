## Docker for Elasticsearch kafka connector

This folder contains instructions and build material for the docker for elasticsearch kafka connector

This docker image contains 4 key components
1. Elasticsearch Kafka Connector installed from confluent hub
1. Debezium-Core jar file, for using `ExtractNewField` transform
  - This is downloaded form mvn repo
1. TimestampConverterAdv Jar file, this is a timestamp converter kafka transform that we built `io.mosip.kafka.connect.transforms.TimestampConverterAdv`, which is built using the existing `org.apache.kafka.connect.transforms.TimstampConverter`
  - This jar is built from the `timstamp_adv` folder
1. DynamicNewField jar file, this is a kafka transform that adds a new field to a document, using existing field and querying another Elasticsearch index `io.mosip.kafka.connect.transforms.DynamicNewField`, which is built using the existing `org.apache.kafka.connect.transforms.InsertField`
  - This jar is built from the `dynamic_new` folder

Then it copies these jar files to build docker image

```sh
$ rm -r jars
$ cd kafka_connect_transforms ; mvn clean package ; cd ..
$ mkdir jars; cd jars
$ cp ../kafka_connect_transforms/target/the_transforms*.jar .
$ wget https://repo.maven.apache.org/maven2/io/debezium/debezium-core/1.7.0.Final/debezium-core-1.7.0.Final.jar
$ cd ..
$ docker build .
```
