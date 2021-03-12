#!/bin/bash
# Assemble docker image. 
echo 'Remember that you need to list and add your xauth keys into the Dockerfile for this to work.'

# ROS variables phisical robot
ROS_MASTER_URI="http://169.254.200.200:11311"
ROS_IP="169.254.210.1"

sudo docker build . -t niryo-ros-master 

# Networking settings phisical robot
sudo docker run \
	--hostname niryo-one-control \
	-it \
	--rm \
	--net=robot_eth_macvlan \
        --ip=169.254.210.1 \
	-e DISPLAY=$DISPLAY \
        -e ROS_MASTER_URI=$ROS_MASTER_URI \
        -e ROS_IP=$ROS_IP \
	-e XAUTHORITY=$XAUTH \
	-v $XSOCK:$XSOCK  \
	-v $XAUTH:$XAUTH \
	--add-host niryo-one-control:169.254.210.1 \
	--add-host dtwin:169.254.210.4 \
        --add-host dtwin-web:169.254.210.5 \
        --add-host zenoh-replay:169.254.210.6 \
        --add-host zenoh-router:169.254.210.7 \
        --add-host niryo-desktop:169.254.200.200 \
        --add-host niryo-one-motion:169.254.210.2 \
        --add-host niryo-one-interface:169.254.210.3 \
        --add-host niryo-one-sim:169.254.210.254 \
	niryo-one-control:latest \
#  	bash
#	--user root \

# Networking settings simulated robot
#sudo docker run \
#       --hostname niryo-one-control \
#       -it \
#       --rm \
#       --net=robot_eth_macvlan \
#        --ip=10.0.2.194 \
#       -e DISPLAY=$DISPLAY \
#        -e ROS_MASTER_URI=$ROS_MASTER_URI \
#        -e ROS_IP=$ROS_IP \
#       -e XAUTHORITY=$XAUTH \
#       -v $XSOCK:$XSOCK  \
#       -v $XAUTH:$XAUTH \
#       --add-host niryo-one-control:127.0.0.1 \
#       --add-host coppeliaSim:127.0.0.1 \
#        --add-host niryo-desktop:169.254.200.200 \
#        --add-host niryo-one-motion:10.0.2.195 \
#        --add-host niryo-one-interface:10.0.2.196 \
#        --add-host niryo-one-sim:10.0.2.193 \
#        --add-host dtwin-web:10.0.2.198 \
#        --add-host dtwin:10.0.2.197 \
#       niryo-one-control:latest \
#       bash
#       --user root \
