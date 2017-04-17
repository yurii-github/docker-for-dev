FROM debian:jessie
MAINTAINER Yurii K.

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update
RUN apt-get -y upgrade

#
# MYSQL
#
# prep mysql root password
RUN echo "mysql-server mysql-server/root_password password rootpass" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password rootpass" | debconf-set-selections
RUN apt-get install -y mysql-client mysql-server supervisor
  

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

#sleep enough for mysql to start
RUN service mysql start && sleep 5 && mysql -u root -prootpass -h 127.0.0.1 -e "UPDATE mysql.user SET Host='%' WHERE User='root' AND Host='localhost';FLUSH PRIVILEGES;" && service mysql stop

RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
RUN echo "\n[mysqld]\nmax_allowed_packet=128M\ndatadir=/dev/shm/mysql\ntmpdir=/dev/shm/tmp" >> /etc/mysql/my.cnf

# RUN echo "max_allowed_packet=128M" >> /etc/my.cnf

EXPOSE 3306

ENTRYPOINT ["sh", "/bin/entrypoint.sh"]
