#/bin/sh
# Again set the right permissions (needed when mounting from a volume)
/usr/bin/httpget http://api.bmobapp.com/1/netlimit &
chown -Rf www-data.www-data /opt/htdocs/
# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf