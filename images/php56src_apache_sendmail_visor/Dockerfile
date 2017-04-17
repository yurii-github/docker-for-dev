#
# OS: Ubuntu 16.04
# SERVER APPS:
#   Apache 2.4.18
#   PHP 5.6.25 (with Xdebug 2.4.1)
#   Sendmail
# DEVEL APPS:
#   git, phpunit(latest/5.5), mysql-client, composer
# DRUPAL CMS:
#   drush(latest/9.dev), potx(1.0)
#
# OTHET APPS:
#   dos2unix, man, nano, wget, htop, iputils-ping
#
# (c) Yurii K, 2016-09-04 , 10h
#
# REFERENCES:
# https://docs.docker.com/engine/reference/builder/
# https://github.com/docker-library/php/blob/2f96a00aaa90ee1c503140724936ca7005273df5/5.6/Dockerfile
# https://github.com/docker-library/php/blob/master/5.6/apache/Dockerfile
# https://xdebug.org/wizard.php
#
# BUILD TIME: 30 m
# IMAGE SIZE: 261 Mb
#
# DIRECTORIES:
#  /var/www/html    - web root
#  /usr/local/lib/php/extensions/no-debug-non-zts-20131226/       - apache modules dir
#
# Installing shared extensions:     /usr/local/lib/php/extensions/no-debug-non-zts-20131226/
# Installing PHP CLI binary:        /usr/local/bin/
# Installing PHP CLI man page:      /usr/local/php/man/man1/
# Installing build environment:     /usr/local/lib/php/build/
# Installing header files:           /usr/local/include/php/
# Installing helper programs:       /usr/local/bin/

FROM ubuntu:16.04
MAINTAINER Yurii K

WORKDIR /usr/src

# fix docker bug to use nano etc
ENV TERM xterm

#
# 1. prepare
#
RUN  apt-get -qq update \
  && apt-get -qq upgrade \
  && apt-get -qq install git dos2unix man nano wget htop iputils-ping mysql-client xz-utils gcc make autoconf

#
# 2. install Apache 2 , configure to use prefork instead of event
#
RUN apt-get -qq install apache2 \
  && a2dismod -f autoindex && a2dismod -f mpm_event && a2enmod mpm_prefork
ADD docker-php.conf /etc/apache2/conf-available/docker-php.conf
RUN a2enconf docker-php \
  && a2enmod rewrite \
  && a2enmod ssl


#
# 3. install/build PHP 5.6
#
RUN apt-get -qq install xz-utils re2c pkg-config libxml2-dev libssl-dev libbz2-dev libcurl4-openssl-dev \
libpq-dev libjpeg-dev libpng-dev libedit-dev libxslt-dev libzip-dev libsqlite3-dev apache2-dev
RUN wget http://ftp.gnu.org/gnu/bison/bison-2.7.tar.xz \
  && tar -xf bison-2.7.tar.xz \
  && cd bison-2.7 \
  && ./configure --silent \
  && make --silent && make install && make clean \
  && mkdir /usr/src/php \
  && mkdir -p /usr/local/etc/php/conf.d
RUN wget https://secure.php.net/get/php-5.6.25.tar.xz/from/this/mirror -O php-5.6.25.tar.xz \
  && tar -xf php-5.6.25.tar.xz -C /usr/src/php --strip-components=1 \
  && cd /usr/src/php \
  && ./configure --silent \
  --with-config-file-path="/usr/local/etc/php" \
  --with-config-file-scan-dir="/usr/local/etc/php/conf.d" \
  --with-apxs2 --with-xsl --with-openssl --with-xmlrpc --with-curl --with-zlib --with-bz2 --with-libzip \
  --with-gd --with-libedit --with-pdo-mysql --with-pdo-pgsql --with-jpeg-dir --with-png-dir \
  --enable-libxml --enable-calendar --enable-exif --enable-ftp --enable-mbstring --enable-intl --enable-soap --enable-zip \
  --disable-ipv6 --disable-cgi --disable-mysqlnd-compression-support --without-pear \
  && make --silent && make install --silent && make clean --silent \
  && cp php.ini-development /usr/local/etc/php/php.ini

#
# Install imagick
# http://www.imagemagick.org/download/  wget && tar xf
# https://github.com/mkoppanen/imagick/tree/3.4.2  phpize ./configure && make && make isntall && echo extension=imagick.so
#TODO!!!


#
# 4. install/build Xdebug and set custom config
#
RUN wget http://xdebug.org/files/xdebug-2.4.1.tgz \
  && tar -xzf xdebug-2.4.1.tgz \
  && cd xdebug-2.4.1 \
  && phpize \
  && ./configure --silent \
  && make --silent \
  && cp modules/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20131226
ADD docker-php.ini /usr/local/etc/php/conf.d/docker-php.ini

#
# 5. setup sendmail
#
# BUG  if pc has non fqdn name mail will be send very slow - 15 sec each.
# Also if you set fqdn name in the another hosts line it will also fail
# So I extend container's name with fqdn
#
RUN apt-get update
RUN apt-get -qq install sendmail
RUN mkdir /opt/yurii-tools
COPY yurii-tools/startup.sh /opt/yurii-tools/startup.sh
RUN chmod +x /opt/yurii-tools/startup.sh
RUN touch /var/log/phpmail.log \
  && chown www-data:www-data /var/log/phpmail.log

#
# 6. add devel tools
# a. PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar \
  && chmod +x phpunit.phar \
  && mv phpunit.phar /usr/local/bin/phpunit
# b. composer
RUN mkdir /opt/composer \
  && wget https://getcomposer.org/composer.phar -O /opt/composer/composer.phar \
  && chmod +x /opt/composer/composer.phar \
  && echo "alias composer='/opt/composer/composer.phar'" >> ~/.bashrc
# c. drush (for Drupal)
RUN mkdir /opt/drush \
  && git clone --single-branch --branch master https://github.com/drush-ops/drush.git /opt/drush
RUN echo "alias drush='/opt/drush/drush'" >> ~/.bashrc
RUN cd /opt/drush \
  && /opt/composer/composer.phar install
# d. potx - tranlsation extractor
RUN wget https://ftp.drupal.org/files/projects/potx-7.x-1.0.tar.gz \
  && tar xvf potx-7.x-1.0.tar.gz \
  && mkdir /opt/drupal \
  && mkdir /opt/drupal/potx \
  && cp potx/potx-cli.php /opt/drupal/potx/ \
  && cp potx/potx.inc /opt/drupal/potx/ \
  && rm potx-7.x-1.0.tar.gz \
  && rm -rf potx \
  && echo "alias drupal_potx='php /opt/drupal/potx/potx-cli.php'" >> ~/.bashrc

#
# 7. install supervisor
#
RUN apt-get -qq install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#
# 8. Cleaning (saves about 200Mb)
#
RUN apt-get -qq remove make gcc xz-utils --purge --auto-remove \
  && rm -rf /var/lib/apt/lists/*  \
  && rm -rf /usr/src/*


EXPOSE 80 443

# RUN
ENTRYPOINT ["/usr/bin/supervisord"]
