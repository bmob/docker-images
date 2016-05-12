FROM mongo:3.2
MAINTAINER Bmob Docker Images "support@bmob.cn"

ENV MONGO_VERSION 3.2.6

# set UTC+8 timezone
ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# mkdir dir
RUN  ["mkdir", "-p", "/opt/mongodb"]
RUN chown -Rf mongodb:mongodb /opt/mongodb

# add mongodb conf
ADD  conf/mongodb.yaml      /etc/mongodb.yaml 

WORKDIR /opt

VOLUME ["/opt"]

CMD [ "mongod", "--config", "/etc/mongodb.yaml" ]