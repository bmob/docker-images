#!/bin/bash
set -e
# Again set the right permissions (needed when mounting from a volume)
#/usr/bin/httpget http://10.45.35.148:8080/1/netlimit &
if [ ! -d /opt/redis ]; then
    mkdir -p /opt/redis
fi

chown -Rf redis:redis /opt/redis
# Start redis server services
redis-server /usr/local/etc/redis/redis.conf