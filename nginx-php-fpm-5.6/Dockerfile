FROM php:5.6-fpm
MAINTAINER Bmob Docker Images "support@bmob.cn"

ENV NGINX_VERSION 1.9.11-1~jessie

# Install Nginx
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
        && echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
        && apt-get update \
        && apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
        && rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
        && ln -sf /dev/stderr /var/log/nginx/error.log

# ADD sources.list    /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
        supervisor \
        git \
        libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        && rm -r /var/lib/apt/lists/*


# Install PHP extensions

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install zip \
        && docker-php-ext-install gd \
        && docker-php-ext-install mbstring \
        && docker-php-ext-install mcrypt \
        && docker-php-ext-install pdo_mysql

# Composer
#ADD composer.phar /usr/local/bin/composer
#RUN chmod 755 /usr/local/bin/composer

# mkdir dir
RUN  ["mkdir", "-p", "/opt/htdocs", "/opt/php", "/opt/nginx/conf.d"]

# Nginx config
RUN rm -Rf /etc/nginx/conf.d/* && \
rm -Rf /etc/nginx/sites-available/default && \
mkdir -p /etc/nginx/ssl/
ADD  nginx.conf      /etc/nginx/nginx.conf
ADD  sites-enabled/*    /opt/nginx/conf.d/

# PHP config
RUN rm -rf /usr/local/etc/php/php.ini
ADD php.ini    /opt/php/php.ini
ADD php-fpm.conf   /usr/local/etc/php-fpm.conf
RUN ln -sf /opt/php/php.ini /usr/local/etc/php/php.ini

RUN chown -Rf www-data.www-data /opt/htdocs
ADD  index.php /opt/htdocs/index.php

# Supervisor Config
ADD supervisord.conf /etc/supervisord.conf

# Start Supervisord
ADD start.sh /start.sh
RUN chmod 755 /start.sh

# Tweak nginx to match the workers to cpu's
RUN procs=$(cat /proc/cpuinfo |grep processor | wc -l) && \
sed -i -e "s/worker_processes 1/worker_processes $procs/" /etc/nginx/nginx.conf

# Write Permission
RUN usermod -u 1000 www-data

EXPOSE 80 443

WORKDIR /opt

VOLUME ["/opt"]

CMD ["/bin/bash", "/start.sh"]