#!/bin/bash

cp -R /var/lib/mysql /dev/shm
mkdir -p /dev/shm/tmp
chown -R mysql:mysql /dev/shm/tmp
chown -R mysql:mysql /dev/shm/mysql


/usr/bin/supervisord