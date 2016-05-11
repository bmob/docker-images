FROM mysql:5.7
MAINTAINER Bmob Docker Images "support@bmob.cn"

ENV MYSQL_VERSION 5.7

# set UTC+8 timezone
ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# mkdir dir
RUN  ["mkdir", "-p", "/opt/mysql/data"]
RUN chown -Rf mysql:mysql /opt/mysql

# Redis config
ADD conf/my.cnf   /etc/mysql/my.cnf

WORKDIR /opt/mysql

VOLUME ["/opt/mysql"]

CMD ["mysqld"]