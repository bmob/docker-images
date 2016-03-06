FROM php:5.6-fpm

# Install env
ADD sources.list    /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
        nginx \
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


# PHP config
ADD php.ini    /usr/local/etc/php/php.ini
ADD php-fpm.conf    /usr/local/etc/php-fpm.conf

# Composer
#ADD composer.phar /usr/local/bin/composer
#RUN chmod 755 /usr/local/bin/composer

# Nginx config
ADD  nginx.conf      /etc/nginx/nginx.conf
ADD  sites-enabled/*    /etc/nginx/conf.d/
RUN  mkdir -p /opt/htdocs 
RUN  mkdir -p /opt/log/nginx
RUN  chown -R www-data.www-data /opt
ADD  index.php /opt/htdocs/

# Tweak nginx to match the workers to cpu's
RUN procs=$(cat /proc/cpuinfo |grep processor | wc -l) && \
sed -i -e "s/worker_processes 1/worker_processes $procs/" /etc/nginx/nginx.conf

WORKDIR /opt

# Write Permission
RUN usermod -u 1000 www-data

EXPOSE 80
VOLUME ["/opt"]
ENTRYPOINT ["/etc/init.d/nginx", "start"]