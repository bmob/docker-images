#!/bin/bash
set -e
# Again set the right permissions (needed when mounting from a volume)
#/usr/bin/httpget http://10.45.35.148:8080/1/netlimit &
if [ ! -d /opt/mysql ]; then
    mkdir -p /opt/mysql
fi

chown -Rf mysql:mysql /opt/mysql
# Start mysql server services
mysqld