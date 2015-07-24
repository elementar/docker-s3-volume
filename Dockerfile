FROM alpine:3.1
MAINTAINER Dave Newman <dave@assembly.com>

RUN apk add --update bash py-pip && pip install awscli
ADD watch /watch

VOLUME /data

ENTRYPOINT [ "./watch" ]
CMD ["/data"]
