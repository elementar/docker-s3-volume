FROM alpine:3.6
MAINTAINER Elementar Sistemas <contato@elementarsistemas.com.br>

RUN apk --no-cache add bash py-pip && pip install awscli
ADD watch /watch

VOLUME /data

ENTRYPOINT [ "./watch" ]
CMD ["/data"]
