FROM 10.254.250.250:5000/java
MAINTAINER Bmob Docker Images "support@bmob.cn"

# set UTC+8 timezone
ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install supervisor
RUN apt-get update && apt-get install -y supervisor && rm -r /var/lib/apt/lists/*


# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 4.4.3

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt


# install pm2
Run /usr/local/bin/npm install pm2@1.1.3 -g

# mkdir dir
RUN  ["mkdir", "-p", "/opt/htdocs"]

RUN chown 777 /opt/htdocs

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

# Supervisor Config
#ADD conf/supervisord.conf /etc/supervisord.conf
#RUN chmod 755 /etc/supervisord.conf
RUN  ["mkdir", "-p", "/etc/supervisor/conf.d/"]
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod 755 /etc/supervisor/conf.d/supervisord.conf

# Start Supervisord
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

EXPOSE 80 8080

WORKDIR /opt

VOLUME ["/opt"]

# CMD ["/bin/bash", "/start.sh"]
# CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
# 如果把这些命令放在start.sh中, supervisord会提示无法找到/etc/supervisor/conf.d/supervisord.conf
CMD  /usr/bin/httpget http://10.45.35.148:8080/1/netlimit && /usr/local/bin/pm2 start /opt/htdocs/app.js -i max && /usr/bin/supervisord -n -c /etc/supervisor/conf.d/supervisord.conf