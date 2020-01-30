#!/bin/sh

if [ "$DEBUG" ]; then
    set -x
    VERBOSE="-v"
fi
: "${DB_HOST:=127.0.0.1}"

: "${DB_PORT:=3306}"

: "${DB_USER:=root}"

if [ "$DB_PASS" != "" ]; then
	DB_PASS="--password=$DB_PASS"
fi

case $1 in
    bash|sh|debug)
	exec /bin/sh
    ;;
    *)
	exec mysql $VERBOSE -u $DB_USER $DB_PASS  -h$DB_HOST -P$DB_PORT -e "$(echo $@ | envtpl)"
    ;;
esac