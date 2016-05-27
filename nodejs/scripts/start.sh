#/bin/sh
# Again set the right permissions (needed when mounting from a volume)
/usr/bin/httpget http://10.45.35.148:8080/1/netlimit &
# start nodejs process
/usr/local/bin/pm2 start /opt/htdocs/app.js -i 1
# Start supervisord and service
echo "start supervisord"
/usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
