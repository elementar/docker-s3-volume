FROM ubuntu:14.04
MAINTAINER Dave Newman <dave@assembly.com>

RUN apt-get update && apt-get -y -q install git python-setuptools python-dateutil python-magic
RUN git clone https://github.com/s3tools/s3cmd.git /s3cmd
RUN cd /s3cmd && python setup.py install

ADD s3cfg /.s3cfg
ADD run.sh run.sh

VOLUME /data

ENTRYPOINT [ "./run.sh", "/data" ]
