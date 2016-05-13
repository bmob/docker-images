#!/bin/bash
set -e
# Again set the right permissions (needed when mounting from a volume)
#/usr/bin/httpget http://10.45.35.148:8080/1/netlimit &
if [ ! -d /opt/mongodb ]; then
    mkdir -p /opt/mongodb
fi

chown -Rf mongodb:mongodb /opt/mongodb
# Start mongod services
mongod --config /etc/mongodb.yaml