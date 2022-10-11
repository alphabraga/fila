FROM php:7.4-apache

RUN apt-get update -y && apt-get install -y libpng-dev ca-certificates curl  libzip-dev zip

RUN \
    docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
    && docker-php-ext-install pdo_mysql \ 
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
  	&& docker-php-ext-install gd \
    && docker-php-ext-install pcntl
    

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'log_errors = On' >> /usr/local/etc/php/conf.d/docker-php-log_errors.ini  

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'session.cache_expire = 1' >> /usr/local/etc/php/conf.d/docker-cache_expire.ini  

RUN pecl install xdebug \
  && echo "[xdebug]" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "zend_extension=xdebug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.mode=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.client_host = \"host.docker.internal\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.idekey=\"VSCODE\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.log=/tmp/xdebug_remote.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]