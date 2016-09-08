# My docker images

Dockerfiles (and other configs) for each image are located in its own branch

So far images that you can build:

* PHP developer: PHP5.6 + Xdebug + Apache + PHPUnit + htop + man + wget


docker-compose.yml example


```yml
version: '2'

services:

  mysql:
    container_name: phpdev_mysql
    image: yurii2017/docker-images:mysql5.6
    network_mode: "host"
    ports:
      - 3306:3306
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=no
      - MYSQL_ROOT_PASSWORD=rootpass

  web:
    container_name: phpdev_web
    image: yurii2017/docker-images:php56_apache
    depends_on:
      - mysql
    volumes:
      - /home/yurii/MyWebApps:/var/www/html
    ports:
      - 80:80
      - 9000:9000
    network_mode: "host"
```
