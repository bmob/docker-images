FROM java:8-jre

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-8/v8.0.33/bin/apache-tomcat-8.0.33.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*



# set UTC+8 timezone
ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# mkdir dir
RUN  ["mkdir", "-p", "/opt/htdocs", "/opt/conf/java"]

# tomcat config
RUN rm -Rf /usr/local/tomcat/conf/server.xml
ADD conf/server.xml    /usr/local/tomcat/conf/server.xml

RUN chmod 755 /opt/htdocs

EXPOSE 8080
CMD ["catalina.sh", "run"]

WORKDIR /opt

VOLUME ["/opt"]


