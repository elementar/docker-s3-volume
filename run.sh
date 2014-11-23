#!/bin/bash

[[ "$TRACE" ]] && set -x

function usage {
	cat <<-EOF
	Usage: $PROGNAME [OPTIONS] <local-path> <remote-path>
	Sync s3 directory locally and backup changed files on exit

	  --force-restore      restore even if local directory is not empty

	   eg: $PROGNAME /data s3://bucket/dir
	EOF
}

function error_exit {
	echo "${1:-"Unknown Error"}" 1>&2
	exit 1
}

PARSED_OPTIONS=$(getopt -n "$0" -o f --long "force-restore" -- "$@")
if [ $? -ne 0 ];
then
  exit 1
fi
eval set -- "$PARSED_OPTIONS"

while true;
do
  case "$1" in
		-f|--force-restore)
      FORCE_RESTORE="true"
      shift;;

    --)
      shift
      break;;
  esac
done

PROGNAME=$0
LOCAL=$1
REMOTE=$2

echo "$# $LOCAL $REMOTE $FORCE_RESTORE"

if [ $# != "2" ]; then
	usage
	error_exit "not enough arguments"
fi

function restore {
  if [ "$(ls -A $LOCAL)" ]; then
		if [[ ${FORCE_RESTORE:false} == 'true' ]]; then
    	error_exit "local directory is not empty"
		fi
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
