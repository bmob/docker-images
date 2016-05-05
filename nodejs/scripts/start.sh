#/bin/sh
# Again set the right permissions (needed when mounting from a volume)
/usr/bin/httpget http://10.45.35.148:8080/1/netlimit &
chown -R 777 /opt/htdocs/
# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
# start nodejs process
/usr/local/bin/pm2 /opt/htdocs/app.js -i max 
