FROM php:7-fpm
MAINTAINER Bmob Docker Images "support@bmob.cn"

ENV NGINX_VERSION 1.9.11-1~jessie

# set UTC+8 timezone
ENV TZ=Asia/Chongqing
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Nginx
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
        && echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
        && apt-get update \
        && apt-get install -y ca-certificates nginx=${NGINX_VERSION} gettext-base \
        && rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
# RUN ln -sf /dev/stdout /var/log/nginx/access.log \
#        && ln -sf /dev/stderr /var/log/nginx/error.log

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

RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
    && mkdir -p xcache \
    && tar -xf xcache.tar.gz -C xcache --strip-components=1 \
    && rm xcache.tar.gz \
    && ( \
        cd xcache \
        && phpize \
        && ./configure --enable-xcache \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r xcache \
    && docker-php-ext-enable xcache

# Composer
#ADD composer.phar /usr/local/bin/composer
#RUN chmod 755 /usr/local/bin/composer

# mkdir dir
RUN  ["mkdir", "-p", "/opt/htdocs", "/opt/conf/php", "/opt/conf/nginx"]

# Nginx config
RUN rm -Rf /etc/nginx/conf.d/* \
    && rm -Rf /etc/nginx/sites-available/default
ADD  conf/nginx.conf      /etc/nginx/nginx.conf
ADD  conf/site-enabled/default.conf    /opt/conf/nginx/default.conf

# PHP config
ADD conf/php.ini    /opt/conf/php/php.ini
ADD conf/php-fpm.conf   /usr/local/etc/php-fpm.conf
RUN ln -sf /opt/conf/php/php.ini /usr/local/etc/php/php.ini

RUN chown -Rf www-data.www-data /opt/htdocs

# Supervisor Config
ADD conf/supervisord.conf /etc/supervisord.conf

# Start Supervisord
ADD scripts/start.sh /start.sh
RUN chmod 755 /start.sh

# Tweak nginx to match the workers to cpu's
#RUN procs=$(cat /proc/cpuinfo |grep processor | wc -l) && \
#sed -i -e "s/worker_processes 1/worker_processes $procs/" /etc/nginx/nginx.conf
RUN sed -i -e "s/worker_processes 1/worker_processes 5/" /etc/nginx/nginx.conf

# Write Permission
RUN usermod -u 1000 www-data

EXPOSE 80

WORKDIR /opt

VOLUME ["/opt"]

CMD ["/bin/bash", "/start.sh"]