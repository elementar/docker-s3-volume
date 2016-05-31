docker-s3-volume
==============

Creates a Docker container that is restored and backed up to a directory on s3. You could use this to run short lived processes that work with and persist data to and from S3.

Forked from: https://github.com/whatupdave/docker-s3-volume

Modified to pass all inputs as environment variables and to use Docker Compose

Usage:

Copy config-sample.env to config.env and edit with your info
run docker-compose up -d

This pulls down the contents of a directory on S3. If the container is stopped or sent a `USR1` signal, it will backup the modified local contents to S3.
