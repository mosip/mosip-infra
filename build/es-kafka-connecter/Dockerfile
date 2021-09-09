FROM confluentinc/cp-kafka-connect

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:latest

ADD ./*.jar /usr/share/java/my_transforms/
