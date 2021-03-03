#!/bin/bash

# Localhost Networking settings
ROS_MASTER_URI="http://10.0.2.193:11311"
ROS_IP="10.0.2.198"

sudo docker build . -t niryo-one-web

# Networking settings simulated robot
#sudo docker run \
#       --hostname dtwin-web \
#       -it \
#       --rm \
#       --net=robot_eth_macvlan \
#        --ip=10.0.2.198 \
#       -e DISPLAY=$DISPLAY \
#        -e ROS_MASTER_URI=$ROS_MASTER_URI \
#        -e ROS_IP=$ROS_IP \
#       -e XAUTHORITY=$XAUTH \
#       -v $XSOCK:$XSOCK  \
#       -v $XAUTH:$XAUTH \
#       --add-host niryo-one-control:10.0.2.194 \
#       --add-host niryo-one-motion:10.0.2.195 \
#       --add-host niryo-one-interface:10.0.2.196 \
#       --add-host niryo-one-sim:10.0.2.193 \
#       --add-host dtwin-web:127.0.0.1 \
#       --add-host dtwin:10.0.2.197 \
#       dtwin-web:latest \
