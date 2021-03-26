#!/bin/bash

# Localhost Networking settings
ROS_MASTER_URI="http://127.0.0.1:11311"
ROS_IP="127.0.0.1"

# Networking settings simulated robot
sudo docker run \
       --hostname niryo-one-web \
       --rm \
       --net=host \
       -e ROS_MASTER_URI=$ROS_MASTER_URI \
       -e ROS_IP=$ROS_IP \
       --add-host niryo-one-control:127.0.0.1 \
       --add-host niryo-one-motion:127.0.0.1 \
       --add-host niryo-one-interface:127.0.0.1 \
       --add-host niryo-one-sim:127.0.0.1 \
       --add-host niryo-one-web:127.0.0.1 \
       --add-host dtwin:127.0.0.1 \
       niryo-one-web:latest
