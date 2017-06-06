# docker-s3-volume

Creates a Docker container that is restored and backed up to a directory on s3.
You could use this to run short lived processes that work with and persist data to and from S3.

Usage:

    docker run -it --rm \
      -e AWS_ACCESS_KEY_ID=... -e AWS_SECRET_ACCESS_KEY=... -e BACKUP_INTERVAL=... \
      elementar/s3-volume s3://<BUCKET>/<PATH>

This pulls down the contents of a directory on S3. If the container is stopped or sent a `USR1` signal,
it will backup the modified local contents to S3.

If you supply a `BACKUP_INTERVAL` environment variable, a backup will be issued each interval. The value can
be specified in seconds, minutes, hours or days (adding `s`, `m`, `h` or `d` as suffix).
