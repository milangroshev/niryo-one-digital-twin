#!/bin/bash

ROS_MASTER_URI="http://168.254.200.200:11311"
ROS_IP="168.254.200.200"

sudo docker build . -t niryo_drivers

sudo docker run \
	-e ROS_MASTER_URI=$ROS_MASTER_URI \
	-e ROS_IP=$ROS_IP \
	--device /dev/gpiomem \
	--device /dev/spidev0.0 \
	--device /dev/spidev0.1 \
	--device /dev/serial0 \
	--device /dev/serial1 \
	--hostname niryo-desktop \
	-it \
	--rm \
	--net=host \
        --add-host niryo-one-control:168.254.200.201 \
        --add-host coppeliaSim:168.254.200.201 \
        --add-host niryo-desktop:168.254.200.200 \
        --add-host twin:168.254.200.201 \
	niryo_drivers:latest \
#	bash
#--user root \
