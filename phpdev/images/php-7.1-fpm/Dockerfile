#
# https://hub.docker.com/_/php/
#
FROM php:7.1-fpm

RUN apt-get update
RUN apt-get -y install wget git zip

#
# get xdebug
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
  && rm composer-setup.php


