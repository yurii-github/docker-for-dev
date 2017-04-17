#
# Contains:
#  - PHP 5.6 (imagick, intl, mcrypt, mysql, sqlite ..)
#  - Apache 2 server
#  - Sendmail server

FROM debian:jessie
MAINTAINER Yurii K.

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get update
RUN apt-get install -y wget nano htop man
RUN apt-get install -y php5 php5-gd supervisor php5-intl php5-mcrypt php5-mysqlnd php5-sqlite php5-imagick php5-xdebug php5-curl
RUN apt-get install -y imagemagick
RUN apt-get update
RUN apt-get install -y sendmail
RUN apt-get install -y mysql-client git
RUN apt-get install -y unzip

ENV TERM xterm

ADD docker-php.conf /etc/apache2/conf-available/docker-php.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN a2ensite default-ssl && a2dismod -f mpm_event && a2enmod mpm_prefork && a2enconf docker-php && a2enmod rewrite && a2enmod ssl
RUN cd / && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout private.key -out cert.crt -subj "/C=NL/ST=Country/L=Kiyv/O=YURII DEV/OU=IT Department/CN=localhost"
RUN chmod 777 /private.key
RUN chmod 777 /cert.crt

COPY default-ssl.conf /etc/apache2/sites-enabled/default-ssl.conf

RUN mkdir /var/xdebug_profiler
RUN chmod 777 -R /var/xdebug_profiler

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# mascarade sendmail as nxte.nl, Google doesn't like our default container domains :/
# https://www.cyberciti.biz/tips/sendmail-masquerading-configuration-howto.html
RUN sed -i.bak '/MAILER_DEFINITIONS/ i MASQUERADE_AS(dev.local)dnl\nFEATURE(masquerade_envelope)dnl\nFEATURE(masquerade_entire_domain)dnl\nMASQUERADE_DOMAIN(dev.local)dnl' /etc/mail/sendmail.mc
RUN m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf

EXPOSE 80 443

ENTRYPOINT ["sh", "/entrypoint.sh"]
