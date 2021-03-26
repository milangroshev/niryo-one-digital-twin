#!/bin/bash

# Localhost Networking settings
ROS_MASTER_URI="http://127.0.0.1:11311"
ROS_IP="127.0.0.1"

sudo docker run \
	--hostname niryo-one-sim \
	--rm \
	--net=host \
        -e ROS_IP=$ROS_IP \
        -e ROS_MASTER_URI=$ROS_MASTER_URI \
	-e DISPLAY=$DISPLAY \
	--add-host niryo-one-sim:127.0.0.1 \
	--add-host niryo-one-web:127.0.0.1 \
	--add-host dtwin:127.0.0.1 \
	niryo-one-sim:latest
