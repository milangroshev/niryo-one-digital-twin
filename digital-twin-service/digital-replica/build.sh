#!/bin/bash

# Assemble docker image. 
echo 'Remember that you need to list and add your xauth keys into the Dockerfile for this to work.'

# ROS variables phisical robot
#ROS_MASTER_URI="http://169.254.200.200:11311"
#ROS_MASTER_URI="http://169.254.210.4:11311"
#ROS_IP="169.254.210.5"

# ROS variables simulated robot
ROS_MASTER_URI="http://10.5.1.201:11311"
ROS_IP="10.5.1.208"


XAUTH_KEYS_="$(xauth list $HOST/unix:0)"
sudo docker build . -t niryo-one-dtwin --build-arg "XAUTH_KEYS_=$XAUTH_KEYS_"


# Robot network
#sudo docker run \
#	--hostname dtwin \
#	-it \
#	--rm \
#	--net=robot_eth_macvlan \
#        --ip=169.254.210.5 \
#	-e DISPLAY=$DISPLAY \
#	-e ROS_MASTER_URI=$ROS_MASTER_URI \
#	-e ROS_IP=$ROS_IP \
#	-e XAUTHORITY=$XAUTH \
#	-v $XSOCK:$XSOCK  \
#	-v $XAUTH:$XAUTH \
#	--add-host dtwin:127.0.0.1 \
#        --add-host niryo-desktop:169.254.200.200 \
#        --add-host niryo-one-control:169.254.210.1 \
#        --add-host niryo-one-motion:169.254.210.2 \
#        --add-host niryo-one-interface:169.254.210.3 \
#        --add-host niryo-one-sim:169.254.210.4 \
#	coppellia_sim:latest \
#	bash 
#--user root \

  	
#localcalhost network
#sudo docker run \
#        -d \
#        --hostname dtwin \
#        -it \
#        --rm \
#        --net=robot_eth_macvlan \
#        --ip=10.5.1.209 \
#        -e ROS_MASTER_URI=$ROS_MASTER_URI \
#        -e ROS_IP=$ROS_IP \
#        -p 5901:5901\
#        -p 6901:6901\
#        --add-host dtwin:127.0.0.1 \
#        --add-host niryo-one-control:10.5.1.202 \
#        --add-host niryo-one-motion:10.5.1.203 \
#        --add-host niryo-one-interface:10.5.1.204 \
#        --add-host niryo-one-sim:10.5.1.201 \
#        --add-host dtwin-web:10.5.1.205 \
#        coppellia_sim:latest \
#       bash
#--user root \
