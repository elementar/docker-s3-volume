FROM ubuntu:16.04
MAINTAINER Dave Newman <dave@assembly.com>

RUN apt-get update && apt-get install -y awscli
ADD watch /watch

RUN mkdir ~/.aws

VOLUME /data

ENTRYPOINT [ "./watch" ]
CMD ["/data"]
