FROM redis:2.8
MAINTAINER Bmob Docker Images "support@bmob.cn"

ENV REDIS_VERSION 2.8.23

# set UTC+8 timezone
ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# mkdir dir
RUN  ["mkdir", "-p", "/opt/redis"]
RUN chown -Rf redis:redis /opt/redis

# Redis config
ADD conf/redis.conf   /usr/local/etc/redis/redis.conf

# Start 
ADD start.sh /start.sh
RUN chmod 755 /start.sh

WORKDIR /opt

VOLUME ["/opt"]

CMD ["/bin/bash", "/start.sh"]