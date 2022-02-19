#!/bin/bash

python2 ./ros-middleware.py 2>&1 > /var/log/ros-middleware.log &

sleep 10

python3.7 -O ./httpd.py 2>&1 > /var/log/httpd.log

#python3.7 -O ./httpd.py
