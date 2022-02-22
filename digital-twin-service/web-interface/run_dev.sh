#!/bin/bash

# Localhost Networking settings
ROS_MASTER_URI="http://10.5.4.101:11311"
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
       --add-host sim-robot:10.5.4.101 \
       --add-host niryo-one-sim:10.5.4.101 \
       --add-host niryo-one-master:10.5.4.101 \
       --add-host niryo-sim-drivers:10.5.4.101 \
       --add-host niryo-one-web:10.5.4.101 \
       --add-host niryo-one-control:10.5.4.101 \
       --add-host niryo-one-motion:10.5.4.101 \
       --add-host niryo-one-interface:10.5.4.101 \
       --add-host niryo-one-dtwin:10.5.4.101 \
       --add-host niryo-one-stack:10.5.4.101 \
       --add-host niryo-desktop:10.5.4.60 \
       10.9.8.105:5000/niryo-one-web:4.0.0
