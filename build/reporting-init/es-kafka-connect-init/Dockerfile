FROM alpine

RUN apk add curl bash vim

RUN mkdir /connectors /kibana_saved_objects

ADD docker-entrypoint.sh /

CMD ["/docker-entrypoint.sh"]
