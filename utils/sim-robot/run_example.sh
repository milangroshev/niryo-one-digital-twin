#!/bin/bash

# Localhost Networking settings
ROS_MASTER_URI="http://127.0.0.1:11311"


sudo docker run \
	--hostname niryo-one-sim \
	-it \
	--rm \
	-d \
	--name niryo-sim-robot \
	--net=host \
        -e ROS_MASTER_URI=$ROS_MASTER_URI \
	--add-host niryo-one-sim:127.0.0.1 \
	--add-host niryo-one-master:127.0.0.1 \
	--add-host niryo-one-web:127.0.0.1 \
	--add-host niryo-one-dtwin:127.0.0.1 \
	niryo-one-sim:latest
