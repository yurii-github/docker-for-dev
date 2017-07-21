#
# https://hub.docker.com/_/php/
#
FROM php:7.1-fpm

RUN apt-get update
RUN apt-get -y install wget git zip man nano

#
# get xDebug
#
RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

#
# get composer
#
RUN wget https://getcomposer.org/installer -O composer-setup.php \
  && php composer-setup.php --install-dir=/bin \
  && rm composer-setup.php && mv /bin/composer.phar /bin/composer

#
# get PHPUnit
#
RUN wget https://phar.phpunit.de/phpunit-6.1.phar -O /bin/phpunit && chmod +x /bin/phpunit


#https://github.com/ngineered/nginx-php-fpm/blob/master/docs/php_modules.md
# /usr/local/bin/docker-php-ext-configure pdo_mysql
RUN /usr/local/bin/docker-php-ext-install pdo_mysql
