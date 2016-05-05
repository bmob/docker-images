FROM node:4.4.3-wheezy
MAINTAINER Bmob Docker Images "support@bmob.cn"

# set UTC+8 timezone
ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install supervisor
RUN apt-get update && apt-get install -y supervisor && rm -r /var/lib/apt/lists/*

# install pm2
Run /usr/local/bin/npm install pm2@1.1.3 -g

# mkdir dir
RUN  ["mkdir", "-p", "/opt/htdocs"]

RUN chown 777 /opt/htdocs

# Supervisor Config
ADD conf/supervisord.conf /etc/supervisord.conf

# Start Supervisord
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# Add net limit
ADD scripts/httpget /usr/bin/httpget
RUN chmod 755 /usr/bin/httpget

# Add cmd restful
RUN  ["mkdir", "-p", "/data/bmob/app/cmdRestful"]
RUN  ["mkdir", "-p", "/data/bmob/app/cmdRestful/conf"]

# cmdRestful from bmob-go/cloud/cmdRestful
ADD scripts/cmdRestful /data/bmob/app/cmdRestful/cmdRestful
ADD conf/app.conf /data/bmob/app/cmdRestful/conf/app.conf
RUN chmod -R 777 /data/bmob/app/cmdRestful

EXPOSE 80 8080

WORKDIR /opt

VOLUME ["/opt"]

CMD ["/bin/bash", "/start.sh"]