FROM alpine:3.10
label maintainer="Elementar Sistemas <contato@elementarsistemas.com.br>"

RUN apk --no-cache add bash py3-pip && pip3 install --no-cache-dir awscli
ADD watch /watch

VOLUME /data

ENTRYPOINT [ "./watch" ]
CMD ["/data"]
