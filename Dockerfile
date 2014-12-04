FROM ubuntu:14.04
MAINTAINER Dave Newman <dave@assembly.com>

RUN apt-get update && apt-get install -y awscli
ADD watch /watch

VOLUME /data

ENTRYPOINT [ "./watch" ]
CMD ["/data"]
