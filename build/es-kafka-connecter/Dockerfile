FROM confluentinc/cp-kafka-connect

RUN confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:11.1.2

ADD ./jars /usr/share/java/my_transforms
