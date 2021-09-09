FROM alpine

RUN apk add curl bash vim

ADD connector_api_calls /
ADD kib_dashboards /
ADD docker-entrypoint.sh /

CMD ["/docker-entrypoint.sh"]
