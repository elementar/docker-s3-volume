#!/bin/bash

function usage {
	echo "Usage: $PROGNAME <local-path> <remote-path>" 1>&2
	echo "   eg: $PROGNAME /data s3://bucket/dir" 1>&2
}

function error_exit {
	echo "${1:-"Unknown Error"}" 1>&2
	exit 1
}

if [ $# != "2" ]; then
	usage
  error_exit "not enough arguments"
fi

PROGNAME=$0
LOCAL=$1
REMOTE=$2

function restore {
  if [ "$(ls -A $LOCAL)" ]; then
    error_exit "local directory is not empty"
  fi

  echo "restoring $REMOTE => $LOCAL"
  if ! s3cmd --access_key="$ACCESS_KEY" --secret_key="$SECRET_KEY" sync "$REMOTE/" "$LOCAL/"; then
    error_exit "restore failed"
  fi
}

function backup {
  echo "backup $LOCAL => $REMOTE"
  if ! s3cmd --access_key="$ACCESS_KEY" --secret_key="$SECRET_KEY" sync --delete-removed "$LOCAL/" "$REMOTE/"; then
    echo "backup failed" 1>&2
    return 1
  fi
}

function final_backup {
  echo "backup $LOCAL => $REMOTE"
  while ! s3cmd --access_key="$ACCESS_KEY" --secret_key="$SECRET_KEY" sync --delete-removed "$LOCAL/" "$REMOTE/"; do
    echo "backup failed" 1>&2
    sleep 1
  done
  exit 0
}

function idle {
  echo "ready"
  while true; do
    sleep 42 &
    wait $!
  done
}

restore

trap final_backup SIGHUP SIGINT SIGTERM
trap "backup; idle" USR1

idle
