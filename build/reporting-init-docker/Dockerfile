FROM alpine

RUN apk add curl bash vim

ADD connector_api_calls /
ADD kibana_saved_objects /
ADD docker-entrypoint.sh /

CMD ["/docker-entrypoint.sh"]
