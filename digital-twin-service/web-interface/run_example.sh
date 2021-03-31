#!/bin/bash

# Localhost Networking settings
ROS_MASTER_URI="http://127.0.0.1:11311"
#ROS_IP="127.0.0.1"

# Networking settings simulated robot
sudo docker run \
       --hostname niryo-one-web \
       -it \
       --rm \
       --net=host \
       --name web-interface \
       -p 8080:8080 \
       -e ROS_MASTER_URI=$ROS_MASTER_URI \
       --add-host sim-robot:10.5.98.5 \
       --add-host niryo-one-sim:127.0.0.1 \
       --add-host niryo-one-master:127.0.0.1 \
       --add-host niryo-sim-drivers:127.0.0.1 \
       --add-host niryo-one-web:127.0.0.1 \
       --add-host niryo-one-control:127.0.0.1 \
       --add-host niryo-one-motion:127.0.0.1 \
       --add-host niryo-one-interface:127.0.0.1 \
       --add-host niryo-one-dtwin:127.0.0.1 \
       --add-host niryo-one-stack:127.0.0.1 \
       niryo-one-web:latest
