# My docker images

Each image (with its dockerfile, config files etc..) is located in its own branch at this repository.  
Currently 2 images are available.


| Base Image     | Image                                | Role           | Entrypoint     | Ports              |  Applications  |
|----------------| -------------------------------------|----------------|:--------------:|--------------------|------:|
| ubuntu:16.04   | yurii2017/docker-images:php56_apache | PHP Developer  | supervisord    | 80<br>443<br>9000  | PH 5.6 (source)<br>Xdebug (source)<br>PHPUnit (lastest)<br>Apache 2.4<br>htop<br>man<br>wget<br>nano |
| mysql:5.6      | yurii2017/docker-images:mysql56      | MySQL Server   | supervisord    | 3306               | MySQL Server 5.6 |


Config example how to use images as developer machine with docker-compose

*docker-compose.yml*

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
      - 443:443
      - 9000:9000
    network_mode: "host"
```
