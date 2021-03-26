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
       --add-host sim-robot:10.5.98.5 \
       --add-host niryo-one-master:10.5.98.108 \
       --add-host niryo-sim-drivers:10.5.98.108 \
       --add-host niryo-one-web:10.5.98.108 \
       --add-host niryo-one-control:10.5.98.108 \
       --add-host niryo-one-motion:10.5.98.108 \
       --add-host niryo-one-interface:10.5.98.108 \
       --add-host niryo-one-dtwin:10.5.98.108 \
       --add-host niryo-one-stack:10.5.98.108 \
       niryo-one-web:latest
