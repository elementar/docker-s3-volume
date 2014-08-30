docker-s3-volume
==============

Docker container that creates a data volume from a path on s3.

Usage:

```
docker run -it --rm \
  -e ACCESS_KEY=... -e SECRET_KEY=... s3-volume s3://<BUCKET>/<PATH>

