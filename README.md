# docker-s3-volume

Creates a Docker container that is restored and backed up to a directory on s3.
You could use this to run short lived processes that work with and persist data to and from S3.

## Usage

For the simplest usage, you can just start the data container:

```bash
docker run -d --name my-data-container \
           elementar/s3-volume /data s3://mybucket/someprefix
```

This will download the data from the S3 location you specify into the
container's `/data` directory. When the container shuts down, the data will be
synced back to S3.

To use the data from another container, you can use the `--volumes-from` option:

```bash
docker run -it --rm --volumes-from=my-data-container busybox ls -l /data
```

### Configuring a sync interval

When the `BACKUP_INTERVAL` environment variable is set, a watcher process will
sync the `/data` directory to S3 on the interval you specify. The interval can
be specified in seconds, minutes, hours or days (adding `s`, `m`, `h` or `d` as
the suffix):

```bash
docker run -d --name my-data-container -e BACKUP_INTERVAL=2m \
           elementar/s3-volume /data s3://mybucket/someprefix
```

### Configuring credentials

If you are running on EC2, IAM role credentials should just work. Otherwise,
you can supply credential information using environment variables:

```bash
docker run -d --name my-data-container \
           -e AWS_ACCESS_KEY_ID=... -e AWS_SECRET_ACCESS_KEY=... \
           elementar/s3-volume /data s3://mybucket/someprefix
```

Any environment variable available to the `aws-cli` command can be used. see
http://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html for more
information.

### Configuring an endpoint URL

If you are using an S3-compatible service (such as Oracle OCI Object Storage), you may want to set the service's endpoint URL:

```bash
docker run -d --name my-data-container -e ENDPOINT_URL=... \
           elementar/s3-volume /data s3://mybucket/someprefix
```

### Forcing a sync

A final sync will always be performed on container shutdown. A sync can be
forced by sending the container the `USR1` signal:

```bash
docker kill --signal=USR1 my-data-container
```

### Forcing a restoration

The first time the container is ran, it will fetch the contents of the S3
location to initialize the `/data` directory. If you want to force an initial
sync again, you can run the container again with the `--force-restore` option:

```bash
docker run -d --name my-data-container \
           elementar/s3-volume --force-restore /data s3://mybucket/someprefix
```

### Using Compose and named volumes

Most of the time, you will use this image to sync data for another container.
You can use `docker-compose` for that:

```yaml
# docker-compose.yaml
version: "2"

volumes:
  s3data:
    driver: local

services:
  s3vol:
    image: elementar/s3-volume
    command: /data s3://mybucket/someprefix
    volumes:
      - s3data:/data
  db:
    image: postgres
    volumes:
      - s3data:/var/lib/postgresql/data
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Credits

* Original Developer - Dave Newman (@whatupdave)
* Current Maintainer - Fábio Batista (@fabiob)

## License

This repository is released under the MIT license:

* www.opensource.org/licenses/MIT
